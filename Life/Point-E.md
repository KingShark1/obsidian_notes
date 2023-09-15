
Tags : #3D #reconstruction

---

![[Pasted image 20230805151929.png]]

```
To produce a 3D object from a text prompt, we first sample an image using the text-to-image model, and then sample a 3D object conditioned on the sampled image. Both of these steps can be performed in a number of seconds, and do not require expensive optimization procedures.
```

---
Image-3D model:
* Stack of [[diffusion]] models, which generate RGB point clouds conditioned on images. For rendering-based-evaluations, meshes are produced from generated point clouds _(marching tetrahedra, I suppose)_ using a regression-based approach.

Generational Process is broken into 3 steps.
1. Generate a synthetic view conditioned on a text caption.
2. Produce a coarse point cloud (1024 points) conditioned on the synthetic view.
3. Produce fine point cloud (4096 points) conditioned on low-resolution point cloud and synthetic view.

---
##### Low Resolution point cloud Generation
We use a conditional, permutation invariant diffusion model 
Extension of framework used by [[Zhou et al. (2021a)]] to include RGB colors for each point in a point cloud.

- Each point cloud is a tensor of shape $K*6$ where  where K is the number of points, inner dimension contains $(x,y,z)$ as well as (RGB) colors. Everything is normalized to range $[-1,1]$.
- These tensors are directly generated via diffusion, starting with random noise of shape $K*6$ , and gradually denoising it.
- [[Transformer]] based model is used to predict both $\epsilon$ and  $\Sigma$  conditioned on the image, timestep $t$, and noised point cloud $x_t$ 
![[Pasted image 20230805170346.png]]
As input context to this model, we run each point in the point cloud through a linear layer with output dimension D, obtaining a K × D input tensor. Additionally, we run the timestep t through a small [[MLP]], obtaining another D-dimensional vector to prepend to the context.

NOTE: No positional encodings are employed, as a result the model itself is permutation-invariant to the input point clouds.

##### High Resolution point cloud Generation
Similar diffusion model, but smaller, which is conditioned on low-resolution point cloud.

##### Data
Several million 3D models and associated metadata. We process the dataset into rendered views, text descriptions, and 3D point clouds with associated RGB colors for each point.

*For each model, Blender script normalizes the model to a bounding box, configures a standard lighting setup and finally exports RGBAD images, using Blender's built-in realtime rendering engine.*

By constructing point clouds directly from renders, we were able to sidestep various issues that might arise from attempting to sample points directly from 3D meshes, such as sampling points which are contained within the model or dealing with 3D models that are stored in unusual file formats.

- **RGBAD Images**:
    
    - The RGBAD images contain color information (R, G, B), depth information (D), and transparency information (A) for each pixel in the image.
    - The color information provides the visual appearance of the 3D model.
    - The depth information indicates the distance from the camera to each pixel, allowing for the reconstruction of the 3D shape.
    - The transparency information helps to account for transparency effects, like glass surfaces.
- **Creating a Dense Point Cloud**:
    
    - For each RGBAD image, the process involves creating a point cloud by using the depth information.
    - Each pixel's depth value is used to calculate the 3D position of a point in space relative to the camera's viewpoint.
    - The RGB color value of the pixel is assigned to the generated point, providing its visual color.
_NOTE_: **I want to have information about the internal points as well.**

---
## Results
- Using single CLIP embedding to condition on images is worse than using a grid of embeddings, meaning the that the point cloud model benefits from seeing (spatial) information from the conditioning image.
- Sometimes 
	1. the model incorrectly interprets the shape of the object depicted in the image.
	2. The model incorrectly infers some parts of shape that is occluded in the image.
- 
---
## IDEAS: 
- Use the output, 1k points from 3 different angles and then use the same merger like architecture to create a better 3d 1k cloud, and then use the upsampler to generate a 4k cloud!
- Preferably segment the interiors when generating the image, and use that segmented data to create the finally merged output
- I can use a transformer based technique rather than merger, as it would hopefully connect the relations between different cloud points.
- **Concatenation of Embeddings**: If the multiple images of the same object represent different perspectives or features, you can concatenate the embeddings of these images along a specific axis (e.g., feature axis). This will result in a new tensor that encapsulates the information from all angles. Depending on the transformer model's capacity, you may need to add additional linear layers to adjust the dimensions to match your existing architecture.
- **Multi-View Encoding**: Design a specific multi-view encoding mechanism that takes into account the spatial relationship between different views. This could involve 3D transformations or specialized layers designed to integrate information across different perspectives. You can then feed this integrated representation into your existing model.
- **Sequential Feeding**: If the temporal relationship between different angles is important, you can feed the images sequentially into the transformer, treating them as a sequence of observations. You may also include angle or perspective information as additional features.
---
## Questions:
1. How are ViT-L/14 CLIP model's last layer embedding $(256*D')$ are **Linearly Projected** to another tensor of shape $256*D$?
2. How to employ positional encodings to generate model with more views?