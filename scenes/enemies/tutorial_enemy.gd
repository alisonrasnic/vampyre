extends CharacterBody2D

const ATTACK = 1.5;

var attack_timer = 0.0;

@export var stats_component: StatsComponent;

func get_width():
	return $CollisionShape2D.shape.get_rect().size.x;

func _process(delta):
	attack_timer += delta;
	if attack_timer >= ATTACK:
		attack_timer = 0.0;
		$AnimationPlayer.play("attack");

func stun():
	$AnimationPlayer.play("stun");

func parry_receive():
	if stats_component:
		stats_component.add_stagger(16.0, null);
	$Parry.play();
	if stats_component and stats_component.is_stunned():
		print($AnimationPlayer.current_animation_length);
		print($AnimationPlayer.current_animation_position);
		#return $AnimationPlayer.current_animation_length - $AnimationPlayer.current_animation_position;
		return 2.0;
	else:
		return null;

func parry_dash_attack_receive():
	var enemy_animplayer = get_node("AnimationPlayer");
	enemy_animplayer.play("explode_death");
	get_node("DashDeath").play();
	await get_node("DashDeath").finished;
	queue_free();