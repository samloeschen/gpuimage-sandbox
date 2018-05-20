//naive 1 bit floyd steinberg

precision lowp float;

varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

const int lookupSize = 16;
const float errorCarry = 0.4;
const vec2 resolution = vec2(1080, 1920);


float getGrayscale(vec2 fragCoord){
    vec2 uv = fragCoord / resolution.xy;
    vec3 sourcePixel = texture2D(inputImageTexture, uv).rgb;
    //contrast sourePixel
    return length(dot(sourcePixel, vec3(0.2126,0.7152,0.0722)));
}


void main () {
    
    vec2 fragCoord = textureCoordinate * resolution;

    float xError = 0.0;
    for(int xLook = 0; xLook < lookupSize; xLook++){
        float grayscale = getGrayscale(fragCoord.xy + vec2(-lookupSize + xLook, 0.0));
        grayscale += xError;
        float bit = grayscale >= 0.5 ? 1.0 : 0.0;
        xError = (grayscale - bit) * errorCarry;

    }
    
    float yError = 0.0;
    for(int yLook = 0; yLook < lookupSize; yLook++){
        float grayscale = getGrayscale(fragCoord.xy + vec2(0.0, -lookupSize + yLook));
        grayscale += yError;
        float bit = grayscale >= 0.5 ? 1.0 : 0.0;
        yError = (grayscale - bit) * errorCarry;
    }
    
    float finalGrayscale = getGrayscale(fragCoord);
    finalGrayscale += (xError * 0.5) + (yError * 0.5);
    float finalBit = finalGrayscale >= 0.5 ? 1.0 : 0.0;

    gl_FragColor = vec4(finalBit, finalBit, finalBit, 1.0);
    
}
