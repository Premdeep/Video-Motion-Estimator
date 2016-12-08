# Video-Motion-Estimator
Advanced Digital Design Class Project (ENGR 852)

Motion estimation is a basic bandwidth compression method, which is used, in video-coding systems. It is a part of predictive coding used in latest hybrid video coding standards such as H.261 and MPEG. This technique utilizes the concept of motion and moving objects in a video and eliminates the redundancy between successive video frames.

Block-base matching methods are the implementations of motion estimation. In block-based method, the image is divided by the encoder into regular blocks. The encoder further codes each block separately and matches it with a region in the previously coded image or images. The result of this process is a displacement vector. Best match is given by the displacement vector which is then chosen and coded. The block difference associated with the chosen vector is then further compressed and coded.
