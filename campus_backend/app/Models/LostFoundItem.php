<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LostFoundItem extends Model
{
    protected $fillable = [
        'user_id',
        'item_name',
        'description',
        'type',
        'phone',
        'image',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

}
