<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreDonationRequest extends FormRequest
{
     public function authorize()
     {
          return true;
     }

     public function rules()
     {
          return [
               'customer_username' => 'required|string|max:255',
               'quantity' => 'required|numeric|min:0',
               'ngo_slug' => 'required|string|max:255',
          ];
     }
}
