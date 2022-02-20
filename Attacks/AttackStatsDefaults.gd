extends Node

export(String) var attack_name
export(String,MULTILINE) var attack_description
export(int) var setup_cost
export(Animation) var setup_anim
export(int) var execute_cost
export(Animation) var execute_anim
export(Shape2D) var hurtbox
export(int) var damage_amount
export(bool) var stuns


export(bool) var shoots_proj = false
export(bool) var proj_pierces
export(Image) var proj_sprite
export(Curve2D) var proj_path
export(Shape2D) var proj_shape
export(int) var proj_damage


export(bool) var places_item
export(Resource) var placable_item

#export var attack_particles
