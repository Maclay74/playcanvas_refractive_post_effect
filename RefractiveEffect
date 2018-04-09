

//--------------- SCRIPT DEFINITION------------------------//
var RefractionEffect = pc.createScript('refcactiveEffect');


RefractionEffect.attributes.add('hideEntity', {
    type: 'boolean',
    title: 'Hide',
    default: true,
    description: "Hide entity from main render (opacity = 0)" 
});

RefractionEffect.attributes.add('blur', {
    type: 'boolean',
    title: 'Blur',
    default: true,
    description: "Blur is nice but it little harms to performance" 
});

RefractionEffect.attributes.add('blurFactor', {
    type: 'number',
    title: 'Blur factor',
    default: 30,
    description: "Blur is nice but it little harms to performance" 
});

RefractionEffect.attributes.add('frequency', {
    type: 'number',
    title: 'Frequency',
    default: 150,
    description: "Less value - smaller waves" 
});

RefractionEffect.attributes.add('frequency', {
    type: 'number',
    title: 'Frequency',
    default: 150,
    description: "Less value - smaller waves" 
});

RefractionEffect.attributes.add('tag', {
    type: 'string',
    title: 'Tag',
    default: "heat-air",
    description: "Select entities by this tag" 
});

RefractionEffect.attributes.add('refractiveMap', {
    type: 'asset',
    assetType: 'texture',
    title: 'Refractive map',
    description: "This texture will be used to refract your map. Should be black-and-white." 
});





// initialize code called once per entity
RefractionEffect.prototype.initialize = function() {
    
    this.entities = this.app.root.findByTag(this.tag);
    
    
    if (!pc.RefractionEffect) this.createEffect(this.app);
    
    
    this.effect = new pc.RefractionEffect(this.app.graphicsDevice);
    this.effect.displacementMap = this.displacementMap;
    this.effect.refractiveMap = this.refractiveMap;
    this.effect.time = 0;
    this.effect.blur = this.blur;
    this.effect.blurFactor = this.blurFactor;
    
    this.on('attr', function (name, value) {
        this.effect[name] = value;
    }, this);

    var queue = this.entity.camera.postEffects;
    queue.addEffect(this.effect);

    this.on('state', function (enabled) {
        if (enabled) {
            queue.addEffect(this.effect);
        } else {
            queue.removeEffect(this.effect);
        }
    });

    this.on('destroy', function () {
        queue.removeEffect(this.effect);
    });
    
    
        
    var texture = new pc.Texture(this.app.graphicsDevice, {
        format: 7,
        width: this.app.graphicsDevice.width,
        height: this.app.graphicsDevice.height,
        depth: 1
    });
    texture.minFilter = 0;
    texture.magFilter = 0;
    texture.addressU = 1;
    texture.addressV = 1;
    
    this.customTarget = new pc.RenderTarget(this.app.graphicsDevice, texture);
    
    this.createProgram();
    
    if (this.hideEntity) this.hideEntities(this.entities);
};

RefractionEffect.prototype.hideEntities = function(entities) {
    
    var material = new pc.StandardMaterial();
    material.opacity = 0;
    material.blendType = 2;
    material.update();
    
    entities.forEach(function(entity) {
        entity.model.material = material;
    });
    
};

RefractionEffect.prototype.createProgram = function() {
    this.app.graphicsDevice.programLib.register('refractive', {
        generateKey: function(device, options) {
            var key = 'refractive';
            
            if (options.color === "0.0") key +="_black";
            if (options.color === "1.0") key +="_white";
            return key;
        },
        createShaderDefinition: function(device, options) {
            // attributes
            var attributes = {
                aPosition: pc.SEMANTIC_POSITION
            };

            
            var vshader = [
                "attribute vec3 aPosition;",
                "",
                "uniform mat4 matrix_model;",
                "uniform mat4 matrix_viewProjection;",
                "",
                "void main(void)",
                "{",
                "    gl_Position = matrix_viewProjection * matrix_model * vec4(aPosition, 1.0);",
                "}"
            ].join("\n");
            
            
            var fshader = [
                "void main(void) {",
                "   gl_FragColor = vec4(" + options.color + ");",
                "}",
               
            ].join("\n");
            
            
            return {
                attributes: attributes,
                vshader: vshader,
                fshader: fshader
            };
        }
    });
}

RefractionEffect.prototype.update = function(dt) {
    
    //var ship = this.app.root.findByName("player");    
    this.effect.time +=dt;
    
    
    var device = this.app.renderer.device; // Устройство для вывода
    var scene = this.app.scene; // Сцена, с котороый мы работаем
    var camera = this.entity.camera.camera;
    
    if (!camera.renderTarget) {
        return false;
    }
       
    var oldTarget = camera.renderTarget;
    
    this.renderer = this.app.renderer; 
    
    camera.renderTarget = this.customTarget;
    this.app.renderer.setCamera(camera);

    device.clear({
        color: [ 0, 0, 0, 0 ],
        depth: 1.0,
        flags: pc.CLEARFLAG_COLOR | pc.CLEARFLAG_DEPTH
    });


    var oldBlending = device.getBlending();
    var oldDepthTest = device.getDepthTest();
    var oldDepthWrite = device.getDepthWrite();
    device.setDepthTest(true);
    device.setDepthWrite(true);
    device.setBlending(true);


    var meshes = this.app.scene.drawCalls;
    
    this.whiteShader = device.programLib.getProgram('refractive', {
        color: "1.0"
    });
    this.blackShader = device.programLib.getProgram('refractive', {
        color: "0.0"
    });
    
    for(var m = 0; m < meshes.length; m++) {
    
        var instance = meshes[m];
        
        if (instance.node) {
            var mesh = instance.mesh;
       
            this.renderer.modelMatrixId.setValue(instance.node.worldTransform.data);
            var material = instance.material;
            

            if (this.whiteShader) {
                 if (instance.node.parent.tags.has("heat-air")) {
                    device.setShader(this.whiteShader);
                } else {
                    device.setShader(this.blackShader);
                }
                
                var style = instance.renderStyle;
                device.setVertexBuffer(mesh.vertexBuffer, 0);
                device.setIndexBuffer(mesh.indexBuffer[style]);
                device.draw(mesh.primitive[style]);
                this.renderer._depthDrawCalls++;
                
            }
        }        
        
    }

    device.setBlending(oldBlending);
    device.setDepthTest(oldDepthTest);
    device.setDepthWrite(oldDepthWrite);
    cleared = false;

    camera.renderTarget = oldTarget;
    this.effect.customTarget = this.customTarget;
    
};

RefractionEffect.prototype.createEffect = function(app) {
    
    pc.extend(pc, function () {
    
        var RefractionEffect = function (graphicsDevice) {

            // Shaders
            var attributes = {
                aPosition: pc.SEMANTIC_POSITION
            };

            var vertextShader = app.assets.find("RefractionVertex", "shader").resource;
            var pixelShader = app.assets.find("RefractionPixel", "shader").resource
                .replace("devicePrecision", graphicsDevice.precision);
                
        
            this.shader = new pc.Shader(graphicsDevice, {
                attributes: attributes,
                vshader: vertextShader,
                fshader: pixelShader
            });

            this.time = 0;
            this.blur = true;
            this.blurFactor = 5;
            this.displacementMap = null;
            this.refractiveMap = null;
            this.customTarget = null;
            this.frequency = 150.0;
        };

        RefractionEffect = pc.inherits(RefractionEffect, pc.PostEffect);

        RefractionEffect.prototype = pc.extend(RefractionEffect, {
            render: function (inputTarget, outputTarget, rect) {
                var device = this.device;
                var scope = device.scope;

                scope.resolve("uColorBuffer").setValue(inputTarget.colorBuffer);
                scope.resolve("uTime").setValue(this.time);
                scope.resolve("uBlur").setValue(this.blur);
                scope.resolve("uFrequency").setValue(this.frequency);
                
                scope.resolve("uBlurFactor").setValue(this.blurFactor / 10000);
                
                
                if (this.customTarget) {
                    scope.resolve("uDisplacementMap").setValue(this.customTarget.colorBuffer);
                }
                
                
                if (this.refractiveMap) {
                    scope.resolve("uRefractiveMap").setValue(this.refractiveMap.resource);
                }
                
    
                pc.drawFullscreenQuad(device, outputTarget, this.vertexBuffer, this.shader, rect);
            }
        });

        return {
            RefractionEffect: RefractionEffect
        };
    }());
    
};
