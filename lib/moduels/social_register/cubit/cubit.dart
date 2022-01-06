
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/moduels/social_register/cubit/states.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates>{
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);


  void userRegister ({
    required String name ,
    required String email ,
    required String password ,
    required String phone ,
})
  {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password)
        .then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          name: name,
          email: email,
          phone: phone,
          uId: value.user!.uid
      );
      //emit(SocialRegisterSuccessState());
    })
        .catchError((error)
    {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name ,
    required String email ,
    required String phone ,
    required String uId ,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write your bio ...',
      cover: 'https://image.freepik.com/free-photo/thinking-young-man-holding-hand-chin-looking-laptop_74855-4080.jpg',
      image: 'https://image.freepik.com/free-photo/thinking-young-man-holding-hand-chin-looking-laptop_74855-4080.jpg',
      isEmailVerified: false ,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(SocialCreateUserSuccessState());
    })
        .catchError((error){
          emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined ;
  bool isPassword = true ;
  void changePasswordVisibility()
  {
    isPassword = !isPassword ;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }

}