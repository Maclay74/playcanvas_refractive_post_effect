precision devicePrecision float;

uniform sampler2D uColorBuffer; // Текстура, вся
uniform sampler2D uDisplacementMap; 
uniform sampler2D uRefractiveMap; 
uniform float uTime; 

uniform bool uBlur; 
uniform float uBlurFactor; 

uniform float uFrequency; 
uniform float uAmplitude; 

varying vec2 vUv0; // Координаты пикселя


const vec3 c_LuminanceWeight = vec3 ( 0.2126, 0.7152, 0.072 );

vec4 blur ( vec2 basecoord, vec2 shift ) {
    return texture2D( uColorBuffer, basecoord + shift ) + 
        texture2D( uColorBuffer, basecoord - shift );
}


void main() {
    
    vec4 displacement = texture2D(uDisplacementMap, vUv0);
    vec2 distortion=vec2(0.0, 0.0);
    vec4 color = texture2D(uColorBuffer, vUv0);
    

    if (displacement.r + displacement.g + displacement.b == 3.0) {
        vec4 refractive = texture2D(uRefractiveMap, vec2(vUv0.x, vUv0.y + uTime / 5.0 ));
        float luminance = (refractive.r + refractive.g + refractive.b) / 3.0;
        distortion = distortion + ((luminance-0.3) / uFrequency) ; 
        
       
        if (uBlur) {
            
            color = (
                blur(vUv0 + distortion, vec2(uBlurFactor, -uBlurFactor) * 0.6) +
                blur(vUv0 + distortion, vec2(-uBlurFactor, uBlurFactor) * 0.6) +
                
                blur(vUv0 + distortion, vec2(uBlurFactor, -uBlurFactor) * 0.4) +
                blur(vUv0 + distortion, vec2(-uBlurFactor, uBlurFactor) * 0.4) +
                
                blur(vUv0 + distortion, vec2(uBlurFactor, -uBlurFactor) * 0.2) +
                blur(vUv0 + distortion, vec2(-uBlurFactor, uBlurFactor) * 0.2) +
                
                texture2D(uColorBuffer, vUv0 + distortion))  / 13.0;
        } else {
            color = texture2D(uColorBuffer, vUv0 + distortion);
        }
    } 
   
    gl_FragColor =  color;

 
}
