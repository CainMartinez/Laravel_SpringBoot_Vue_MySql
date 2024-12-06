<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterUserRequest extends FormRequest
{
     public function authorize()
     {
          return true; // Permitir siempre
     }

     public function rules()
     {
          $role = $this->input('role');

          return [
               'role' => 'required|string|in:waiter,manager',
               'firstName' => 'required|string|max:100',
               'lastName' => 'required|string|max:100',
               'email' => 'required|string|email|max:150|unique:' . ($role === 'waiter' ? 'Waiter' : 'Manager') . ',email',
               'password' => 'required|string|min:6',
               'repeatPassword' => 'required|same:password',
          ];
     }

     public function messages()
     {
          return [
               'repeatPassword.same' => 'The repeatPassword must match the password.',
          ];
     }
}
