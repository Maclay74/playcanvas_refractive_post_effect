# PlayCanvas Refractive Post Effect

![refractive_effect|690x434](https://forum-files-playcanvas-com.s3-eu-west-1.amazonaws.com/original/2X/f/fe99e4a156cf170b4f7056f1de47bfd0f161b67e.gif)

Demo project - https://playcanvas.com/project/546676/

So if your scene has things as hot as this bear, you need this **post-effect** to be used by your camera.

Firstly, clone the repo and add files to your assets.

https://github.com/Mikecoon/playcanvas_refractive_post_effect

Then, add script component to your active camera and choose **refractiveEffect**.

![image|323x126](https://forum-files-playcanvas-com.s3-eu-west-1.amazonaws.com/original/2X/f/ff5f6adec6d7f2ad9cc9d96194f761ace5ff7339.png)

There are default settings, I guess it's okay to start. The only this you have to set it Refractive Map. Select texture from repo.

![image|318x272](https://forum-files-playcanvas-com.s3-eu-west-1.amazonaws.com/original/2X/b/b39b376bfa250698ecf3e16a153050935a966324.png)

You're brilliant!  We got so far!

Now we have to add some primitives to our scene. They will refract it.

![image|581x500](https://forum-files-playcanvas-com.s3-eu-west-1.amazonaws.com/optimized/2X/2/28c6194381ee7d8057a9d082e33eec150bd884c5_1_581x500.jpg)

And add **heat-air** tag to them. You can change it in script's options, by the way.

![image|316x149](https://forum-files-playcanvas-com.s3-eu-west-1.amazonaws.com/original/2X/c/c41fdfb3ad8962c369c11a2722b7c0091d9337e5.png)

Also, this effect has **build-in blur** and you can configure it by options. Or just turn it off.

To be honest, now this effect is not really good for performance, because it renders the whole scene twice (regular render and masked) but I'll optimize it. When time will come.
