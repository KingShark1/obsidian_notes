Neural Attenuation Fields for Sparse-View CBCT Reconstruction


---
Tags :

 #NeRF 

---

                       NAF                          Ground Truth

![[Pasted image 20230831124854.png]]![[Pasted image 20230831124910.png]]

A fast self-supervised solution for sparse view C.B.C.T reconstruction.
No requirements for external CT scans but the X-ray projections of the interested objects.

1. Parameterise the attenuation coefficient field as an INR and imitates the X-ray attenuation process with a self-supervised network pipeline.
	Meaning : [[MLP]] is trained whose input is an encoded spatial coordinate (x, y, z) and whose output is the attenuation coefficient $\mu$ at that location. A hash encoding is utilised, a learning based positional encoder, to help the network quickly learn high-frequency

[[NAF]] consists of 4 modules :
1. Ray Sampling
		Uniformly sample points along X-ray paths based on the scanner geometry.
2. Position Encoding
		A position encoder network then encodes their spatial coordinates to extract valuable features.
3. Attenuation Coefficient prediction
		An [[MLP]] network consumes the encoded information and predicts attenuation coefficients.
4. Projection Synthesis
		Synthesise projections by attenuating incident X-rays according to the predicted attenuation coefficients on their paths.

Hash encoder is used to learn simple characteristics of muscles(spindles) and bones(cylinder). Their smooth surfaces can be easily learned with low-dimensional features.

Hash encoder describes a bounded space by L multi-resolution voxel grids. A trainable feature lookup table Θ with size T is assigned to each voxel grid.

# Tasks for NAF - CBCT

NOTE : Train with all data at the same time, once that is done, evaluate results and then move on to training data of the same type of tooth in one version of NAF, i.e overtrain/specialize NAF in one version of tooth only.
- [ ] Modify DataGenerator and create custom dataset for all ~700 tooths.
- [ ] Try the train script and see how that works.
- [ ] There is no inference script, so search that, otherwise that'd be needed to be written from scratch.