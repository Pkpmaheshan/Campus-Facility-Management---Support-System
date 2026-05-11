<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NeedItem extends Model
{
protected $fillable = [
    'user_id',
    'items',
    'location',
];
}
