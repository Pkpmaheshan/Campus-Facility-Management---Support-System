<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestModel extends Model
{
    use HasFactory;
protected $fillable = [
    'user_id',
    'type',
    'title',
    'description',
    'image',
    'location',
    'priority',
    'status',
    'assigned_to'
];
    public function user()
{
    return $this->belongsTo(User::class);
}
}
