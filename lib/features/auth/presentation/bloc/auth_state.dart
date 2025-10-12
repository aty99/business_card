import 'package:equatable/equatable.dart';
import '../../data/model/user_model.dart';

/// Base class for authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state (processing authentication)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state (user is logged in)
class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state (user is not logged in)
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Error state (authentication failed)
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

