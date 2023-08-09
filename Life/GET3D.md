Tags : #GAN #3D #reconstruction 

## A generative model of high quality 3D Textured Shapes Learned from images.

GOAL : Learn $M, E = G(z)$ to map a Gaussian Distribution $z \in (0, I)$ to a mesh $M$ with texture $E$. 

---

### Method

Generation Process - 
1.) A geometry Branch
2.) Texture Branch
During training, an efficient differentiable rasterizer is utilized to render the resulting
textured mesh into 2D high-resolution images. The entire process is differentiable, allowing for adversarial training from images (with masks indicating an object of interest) by propagating the gradients from the 2D [[discriminator]] to both generator branches.

Generative model for 3d Textured Meshes
