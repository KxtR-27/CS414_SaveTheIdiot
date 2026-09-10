@abstract
class_name BaseCharacter
extends CharacterBody2D

@export_group("")
@export var speed: float = 3000.0
@export var health: float = 100.0

@export_group("Components")
@export var health_component: HealthComponent
@export var damage_component: DamageComponent
