shader_type canvas_item;
render_mode unshaded;
uniform bool is_greyscale = true;

void fragment(){
	if (is_greyscale){
		COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
		float lumi = (COLOR.r + COLOR.g + COLOR.b)/3.0;
		COLOR.rgb = vec3(lumi);
	} else {
		
	}
}