GDPC                P                                                                         T   res://.godot/exported/133200997/export-218e951c179d1aaade823e5b46c015cf-object.scn   %      �      ���34�� Ay���    P   res://.godot/exported/133200997/export-e71838b5e531267044f615ce022c4372-main.scn�      �
      3<�Kl��c���]8/    ,   res://.godot/global_script_class_cache.cfg  `9             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�*      �      �̛�*$q�*�́     D   res://.godot/imported/icon.svg-3540dd99eafb6c4e602e8c59cee418fa.ctex�      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  @=             Pčg�ݷ�CzBI�       res://icon.svg  �9      �      C��=U���^Qu��U3       res://icon.svg.import   �7      �       �\�"ν�<�D�ш�P       res://project.binary�=      R      kx�4�.��^��☄^       res://scripts/main.gd           L      �`��5k�����5�;       res://scripts/object.gd P      L      *I���O���k&QV       res://scripts/score.gd  �      �       8����V�� �� �d+       res://scripts/signal_bus.gd p      T       :\J���N'��f�J�        res://textures/icon.svg.import  �      �       ��[60�-��oY�B       res://ui/main.tscn.remap�8      a       �.>v�iߝ�B�� ���       res://ui/object.tscn.remap  �8      c       X�`��ɱcb�Y5P        extends Node2D

@onready var marker_left = $"Marker Left"
@onready var marker_right = $"Marker Right"
@onready var marker_next_object = $"Marker Next Object"
@onready var marker_full = $"Marker Full"
@onready var label_game_over = $"Canvas/Game Over"
var obj_scene := preload("res://ui/object.tscn")
var current_object
var next_object
var is_game_over = false

func _ready() -> void:
	current_object = create_object((marker_left.global_position + marker_right.global_position) / 2)
	next_object = create_object(marker_next_object.global_position)
	SignalBus.container_full.connect(on_game_over)

func _physics_process(delta: float) -> void:
	if is_game_over:
		return

	if current_object != null:
		# Object to unfollow the cursor on drop
		if current_object.gravity_scale == 0:
			var object_pos_x = get_object_x_position()
			current_object.global_position.x = object_pos_x
			current_object.global_position.y = marker_left.global_position.y
		if Input.is_action_just_pressed("drop"):
			drop_object()

func create_object(position):
	var new_obj = obj_scene.instantiate()
	new_obj.disable_physics()
	new_obj.global_position = position
	new_obj.size = randi_range(1, 5)
	add_child(new_obj)
	return new_obj

func get_object_x_position():
	return clamp(
		get_global_mouse_position().x,
		marker_left.global_position.x,
		marker_right.global_position.x
	)

func drop_object():
	current_object.enable_physics()
	# To prevent spawning spam, set it to null,
	# then check it on _physics_process
	current_object = null
	await get_tree().create_timer(0.5).timeout
	current_object = next_object
	next_object = create_object(marker_next_object.global_position)

func on_game_over(height: float):
	if height < marker_full.global_position.y:
		is_game_over = true
		label_game_over.visible = true
		#await get_tree().create_timer(5).timeout
		#get_tree().reload_current_scene()
    extends RigidBody2D

var obj_scene = preload("res://ui/object.tscn")
@onready var collision = $Collision
var max_size = 10
var size = 1

func _ready() -> void:
	collision.shape.radius = size * 10
	mass = (size^2) * PI
	body_entered.connect(handle_merge_on_contact)

func _draw() -> void:
	var color = Color.from_hsv(float(size) / max_size, 1, 1)
	draw_circle(Vector2.ZERO, collision.shape.radius, color)

func handle_merge_on_contact(body):
	if is_queued_for_deletion() or not body.is_in_group("objects"):
		return
	
	var new_obj_position = (global_position + body.global_position) / 2
	SignalBus.container_full.emit(new_obj_position.y)
	
	if body.size != size:
		return

	body.queue_free()
	queue_free()

	if size < max_size:
		var obj = obj_scene.instantiate()
		obj.enable_physics()
		obj.global_position = new_obj_position
		obj.size = size + 1
		get_parent().add_child.call_deferred(obj)

	SignalBus.object_removed.emit(size)

func enable_physics():
	gravity_scale = 1
	collision_layer = 1
	collision_mask = 1

func disable_physics():
	gravity_scale = 0
	collision_layer = 0
	collision_mask = 0
    extends Label

var current_score = 0

func _ready() -> void:
	SignalBus.object_removed.connect(update_score)

func update_score(size: int):
	current_score += size ^ 2
	text = str(current_score)
              extends Node

signal object_removed(size: int)
signal container_full(height: float)
            GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://c802nwf6xdvbn"
path="res://.godot/imported/icon.svg-3540dd99eafb6c4e602e8c59cee418fa.ctex"
metadata={
"vram_texture": false
}
                RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script 	   _bundled       Script    res://scripts/main.gd ��������   Script    res://scripts/score.gd ��������      local://LabelSettings_rxxmf @         local://LabelSettings_s4jti j         local://LabelSettings_ny2s8 �         local://PackedScene_rcbyu �         LabelSettings          (            LabelSettings                      LabelSettings          F           �?��;?��9?  �?                            PackedScene          	         names "          Suika    script    Node2D    ContainerShape    StaticBody2D    CollisionPolygon2D 	   position    polygon    Border Left    offset_left    offset_top    offset_right    offset_bottom    color    metadata/_edit_use_anchors_ 
   ColorRect    Border Right    Border Bottom    Canvas    CanvasLayer    Score    text    label_settings    Label    Next Object 
   Game Over    visible    Marker Left 	   Marker2D    Marker Right    Marker Next Object    Marker Full    	   variants    $             
    ��C  ��%        `A  �B      �B     �D �D �D �D  �B @D  �B @D  D  `A  D    ��C     �B    ��C    @D     �?���>���>  �?          �UD     YD    �D    �_D     �B    �iD      C      0                         cC     �B    ��C     C      Next                     ��C    ��C    @GD     �C   
   GAME OVER          
     �C  �A
    �OD  �A
     yC  2C
     �C  �B      node_count             nodes     �   ��������       ����                            ����                     ����                                ����   	      
                                               ����   	   	   
         
                                      ����   	      
         
                                       ����                     ����   	      
                                                           ����   	      
                                                     ����         	      
                                                ����                            ����      !                     ����      "                     ����      #             conn_count              conns               node_paths              editable_instances              version             RSRC               RSRC                    PackedScene            ��������                                            
      resource_local_to_scene    resource_name 	   friction    rough    bounce 
   absorbent    script    custom_solver_bias    radius 	   _bundled       Script    res://scripts/object.gd ��������
   Texture2D    res://textures/icon.svg +�l43�c      local://PhysicsMaterial_kba7c �         local://CircleShape2D_37adg          local://PackedScene_3nnet S         PhysicsMaterial            �>      ��>         CircleShape2D                      B         PackedScene    	      	         names "         Object    collision_layer    collision_mask    physics_material_override    gravity_scale    max_contacts_reported    contact_monitor    script    objects    RigidBody2D 
   Collision    shape    debug_color    CollisionShape2D    Texture    scale    texture 	   Sprite2D    	   variants    
                                                             ��Y?���>��?���>
   ��S>��S>               node_count             nodes     ,   ��������	       ����                                                                
   ����                                 ����            	             conn_count              conns               node_paths              editable_instances              version             RSRC       GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://df3l7653854en"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-e71838b5e531267044f615ce022c4372-main.scn"
               [remap]

path="res://.godot/exported/133200997/export-218e951c179d1aaade823e5b46c015cf-object.scn"
             list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             +�l43�c   res://textures/icon.svgQ���.   res://ui/main.tscne'H��7   res://ui/object.tscn	r��	i   res://icon.svg ECFG      application/config/name      
   SuikaClone     application/run/main_scene         res://ui/main.tscn     application/config/features$   "         4.1    Forward Plus       application/config/icon         res://icon.svg     autoload/SignalBus$         *res://scripts/signal_bus.gd   input/move_left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/move_right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script      
   input/dropt              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           echo          script                    