//naive 1 bit floyd steinberg
varying vec2 textureCoordinate;
varying vec2 resolution;
uniform vec3 colorToReplace;
uniform sampler2D inputImageTexture;

const int lookupSize = 64;
const float errorCarry = 0.3;

float getGrayscale () {
    vec2 = textureCoordinate;
    vec3 sourcePixel = texture2D(inputImageTexture, uv).rgb;
    return length(sourcePixel*vec3(0.2126,0.7152,0.0722));
}

void main () {
    
    int topGapY = int(resolution.y - fragCoord.y);
    
    int cornerGapX = int((fragCoord.x < 10.0) ? fragCoord.x : resolution.x - fragCoord.x);
    int cornerGapY = int((fragCoord.y < 10.0) ? fragCoord.y : resolution.y - fragCoord.y);
    int cornerThreshhold = ((cornerGapX == 0) || (topGapY == 0)) ? 5 : 4;
    
    if (cornerGapX+cornerGapY < cornerThreshhold) {
        
        fragColor = vec4(0,0,0,1);
        
    } else if (topGapY < 20) {
        
        if (topGapY == 19) {
            
            fragColor = vec4(0,0,0,1);
            
        } else {
            
            fragColor = vec4(1,1,1,1);
            
        }
        
    } else {
        
        float xError = 0.0;
        for(int xLook=0; xLook<lookupSize; xLook++){
            float grayscale = getGrayscale(fragCoord.xy + vec2(-lookupSize+xLook,0));
            grayscale += xError;
            float bit = grayscale >= 0.5 ? 1.0 : 0.0;
            xError = (grayscale - bit)*errorCarry;
        }
        
        float yError = 0.0;
        for(int yLook=0; yLook<lookupSize; yLook++){
            float grayscale = getGrayscale(fragCoord.xy + vec2(0,-lookupSize+yLook));
            grayscale += yError;
            float bit = grayscale >= 0.5 ? 1.0 : 0.0;
            yError = (grayscale - bit)*errorCarry;
        }
        
        float finalGrayscale = getGrayscale(fragCoord.xy);
        finalGrayscale += xError*0.5 + yError*0.5;
        float finalBit = finalGrayscale >= 0.5 ? 1.0 : 0.0;
        
        gl_FragColor = vec4(finalBit,finalBit,finalBit,1);
        
    }
}
