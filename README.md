# blender-container-rendering

If you would like to run rendering for your arts designed in Blender Open Source 3D modeler in containers, this is ready to go solution based on Ubuntu 20.04 Linux based on image. Your Pull Requests and/or Issues are welcome in this project.

## How it works?
It's important, because blender is running in containter and fetching *.blend file from web server, next running rendering on first frame in Blender and push output image - rendered image - to object storage MinIO (to randomly generated bucket with UUID named).

### Your Blender's project file need to have specific settings
* render with CPU (like Cycles)
* output file settings to image (i.e. PNG) or in case of animation (i.e. MKV)


[Inspiration](https://github.com/OpenShiftDemos/blender-remote) based on Linux RedHat container base image and similar idea with rendering process contenerization.


## Requirements for host OS environement

* installed Ubuntu 20.04 Linux
* preinstalled docker.io
* free space on disk
* terminal

## Required services on host OS
* MinIO Open Source S3 service + web UI
* simple HTTP web server for serving catalog


## How to run?

### Run required services

#### MiniIO in one terminal (destination object-storage for rendered scenes/frames)
```bash
docker run -p 9000:9000 -p 9001:9001   quay.io/minio/minio server /data --console-address ":9001"
```

#### Simple HTTP web server with Python in second terminal (this is catalog with *.blend files for rendering)
```bash
cd example-blender-2.9-file/
python3 -m http.server --directory .
```

### Building container local image
```bash
# build Docker image
cd cpu-rendering/
docker build . -t blender-container-rendering
```

### Run container with rendering (executing in frame buffer X server inside Docker container)
```bash
MY_LOCAL_NET_INTERFACE=wlo1
MY_LOCAL_IP=$(ip -o -4 addr list $MY_LOCAL_NET_INTERFACE | awk '{print $4}' | cut -d/ -f1)

docker run --rm -e BLEND_LOCATION=http://$MY_LOCAL_IP:8000/file_name_with_blender_art_frame_1_to_render.blend -e RENDER_START_FRAME=1 -e RENDER_END_FRAME=1 -e S3_ENDPOINT=http://$MY_LOCAL_IP:9000 -e S3_KEY=minioadmin -e S3_SECRET=minioadmin blender-container-rendering:latest
```


### Example rendering logs for one frame
```bash
$ docker run --rm -e BLEND_LOCATION=http://$MY_LOCAL_IP:8000/cactus_01.blend -e RENDER_START_FRAME=1 -e RENDER_END_FRAME=1 -e S3_ENDPOINT=http://$MY_LOCAL_IP:9000 -e S3_KEY=minioadmin -e S3_SECRET=minioadmin blender-container-rendering:latest
Checking environment
Setting UUID for job...
Job UUID: 075fd0a3-7331-4f63-97ca-faccf3057b4c
Fetching the blend file...
Location: http://192.168.1.9:8000/cactus_01.blend
2023-04-12 16:42:41 URL:http://192.168.1.9:8000/cactus_01.blend [35781944/35781944] -> "/tmp/job.blend" [1]
root          10  0.0  0.0 141832 26152 ?        R    16:42   0:00 Xvfb :1 -screen 0 1024x768x16
root          12  0.0  0.0   3312   660 ?        S    16:42   0:00 grep X

Rendering scene(s)
-rw-r--r-- 1 root root 35781944 Apr 11 18:58 /tmp/job.blend
Start rendering with below parameters:
INPUT_FILE_PATH: '/tmp/job.blend'
ARG_EXT: ' -o /tmp/output/ -f 1'
Blender 2.93.16 (hash 1668424eef81 built 2023-03-21 00:38:52)
Read blend: /tmp/job.blend
Fra:1 Mem:301.07M (Peak 301.72M) | Time:00:01.16 | Syncing Light
Fra:1 Mem:301.07M (Peak 301.72M) | Time:00:01.16 | Syncing Camera
Fra:1 Mem:301.24M (Peak 301.72M) | Time:00:01.16 | Syncing Sphere
GPU failed to find function node_bsdf_hair
Fra:1 Mem:308.36M (Peak 308.54M) | Time:00:01.66 | Syncing Cone
Fra:1 Mem:308.37M (Peak 308.54M) | Time:00:01.66 | Syncing Plane
Fra:1 Mem:317.62M (Peak 318.13M) | Time:00:01.67 | Syncing Icosphere
Fra:1 Mem:317.81M (Peak 318.13M) | Time:00:01.83 | Syncing Plane.001
Fra:1 Mem:327.07M (Peak 327.57M) | Time:00:01.83 | Syncing Plane.002
Fra:1 Mem:336.32M (Peak 336.82M) | Time:00:01.84 | Syncing Cube
Fra:1 Mem:336.72M (Peak 337.23M) | Time:00:02.75 | Syncing Cube.001
Fra:1 Mem:336.74M (Peak 337.23M) | Time:00:02.75 | Syncing Cube.002
Fra:1 Mem:336.76M (Peak 337.23M) | Time:00:02.75 | Syncing Text
Fra:1 Mem:337.20M (Peak 337.29M) | Time:00:03.01 | Syncing Icosphere.005
Fra:1 Mem:337.21M (Peak 337.29M) | Time:00:03.01 | Syncing Sphere.005
Fra:1 Mem:337.31M (Peak 337.42M) | Time:00:03.01 | Syncing Sphere.011
Fra:1 Mem:337.38M (Peak 337.42M) | Time:00:03.01 | Syncing Sphere.010
Fra:1 Mem:337.48M (Peak 337.48M) | Time:00:03.01 | Syncing Sphere.019
Fra:1 Mem:337.57M (Peak 337.57M) | Time:00:03.01 | Syncing Sphere.020
Fra:1 Mem:337.64M (Peak 337.64M) | Time:00:03.01 | Syncing Sphere.021
Fra:1 Mem:337.74M (Peak 337.74M) | Time:00:03.01 | Syncing Sphere.016
Fra:1 Mem:337.87M (Peak 337.87M) | Time:00:03.01 | Syncing Sphere.017
Fra:1 Mem:337.94M (Peak 337.94M) | Time:00:03.01 | Syncing Sphere.018
Fra:1 Mem:338.04M (Peak 338.04M) | Time:00:03.01 | Syncing Sphere.007
Fra:1 Mem:338.11M (Peak 338.24M) | Time:00:03.01 | Syncing Sphere.008
Fra:1 Mem:338.19M (Peak 338.24M) | Time:00:03.01 | Syncing Sphere.009
Fra:1 Mem:338.26M (Peak 338.37M) | Time:00:03.01 | Syncing Sphere.012
Fra:1 Mem:338.33M (Peak 338.37M) | Time:00:03.01 | Syncing Sphere.013
Fra:1 Mem:338.41M (Peak 338.41M) | Time:00:03.01 | Syncing Sphere.014
Fra:1 Mem:338.48M (Peak 338.48M) | Time:00:03.01 | Syncing Sphere.015
Fra:1 Mem:338.55M (Peak 338.55M) | Time:00:03.01 | Syncing Sphere.022
Fra:1 Mem:338.63M (Peak 338.63M) | Time:00:03.01 | Syncing Sphere.023
Fra:1 Mem:338.70M (Peak 338.70M) | Time:00:03.01 | Syncing Sphere.024
Fra:1 Mem:338.77M (Peak 338.77M) | Time:00:03.01 | Syncing Sphere.006
Fra:1 Mem:338.85M (Peak 338.85M) | Time:00:03.01 | Syncing Icosphere.001
Fra:1 Mem:338.86M (Peak 339.05M) | Time:00:03.01 | Syncing Icosphere.002
Fra:1 Mem:338.87M (Peak 339.05M) | Time:00:03.01 | Syncing Icosphere.003
Fra:1 Mem:338.88M (Peak 339.05M) | Time:00:03.01 | Syncing Icosphere.004
Fra:1 Mem:338.89M (Peak 339.05M) | Time:00:03.01 | Syncing Icosphere.006
Fra:1 Mem:338.90M (Peak 339.05M) | Time:00:03.01 | Syncing Icosphere.007
Fra:1 Mem:338.92M (Peak 339.05M) | Time:00:03.01 | Syncing Icosphere.008
Fra:1 Mem:338.93M (Peak 339.05M) | Time:00:03.01 | Syncing Sphere.001
Fra:1 Mem:339.00M (Peak 339.13M) | Time:00:03.01 | Syncing Sphere.002
Fra:1 Mem:339.07M (Peak 339.13M) | Time:00:03.01 | Syncing Sphere.003
Fra:1 Mem:339.15M (Peak 339.28M) | Time:00:03.01 | Syncing Sphere.004
Fra:1 Mem:325.83M (Peak 339.28M) | Time:00:03.06 | Syncing Light
Fra:1 Mem:325.83M (Peak 339.28M) | Time:00:03.06 | Syncing Camera
Fra:1 Mem:326.00M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Cone
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Plane
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Plane.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Plane.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Cube
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Cube.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Cube.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Text
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.005
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.005
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.011
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.010
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.019
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.020
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.021
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.016
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.017
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.018
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.007
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.008
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.009
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.012
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.013
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.014
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.015
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.022
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.023
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.024
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.006
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.003
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.004
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.006
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.007
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Icosphere.008
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.003
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.06 | Syncing Sphere.004
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Light
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Camera
Fra:1 Mem:326.06M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Cone
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Plane
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Plane.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Plane.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Cube
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Cube.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Cube.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Text
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.005
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.005
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.011
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.010
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.019
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.020
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.021
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.016
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.017
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.018
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.007
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.008
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.009
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.012
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.013
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.014
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.015
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.022
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.023
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.024
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.006
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.003
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.004
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.006
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.007
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Icosphere.008
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.001
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.002
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.003
Fra:1 Mem:325.88M (Peak 339.28M) | Time:00:03.11 | Syncing Sphere.004
Fra:1 Mem:325.89M (Peak 339.28M) | Time:00:03.48 | Rendering 1 / 65 samples
Fra:1 Mem:303.25M (Peak 339.28M) | Time:01:19.40 | Rendering 26 / 64 samples
Fra:1 Mem:303.25M (Peak 339.28M) | Time:02:33.46 | Rendering 51 / 64 samples
Fra:1 Mem:303.25M (Peak 339.28M) | Time:03:12.31 | Rendering 64 / 64 samples
Append frame 1
 Time: 03:15.70 (Saving: 00:00.32)


Blender quit
Output dir: /tmp/output listing:
total 20
drwxr-xr-x 2 root root  4096 Apr 12 16:42 .
drwxrwxrwt 1 root root  4096 Apr 12 16:45 ..
-rw-r--r-- 1 root root 11262 Apr 12 16:45 0001-0101.mkv
Configuring minio client...
Added `destination` successfully.
Creating bucket: 075fd0a3-7331-4f63-97ca-faccf3057b4c...
Bucket created successfully `destination/075fd0a3-7331-4f63-97ca-faccf3057b4c`.
Copying output file: /tmp/output/0001-0101.mkv to bucket: 075fd0a3-7331-4f63-97ca-faccf3057b4c...
`/tmp/output/0001-0101.mkv` -> `destination/075fd0a3-7331-4f63-97ca-faccf3057b4c/0001-0101.mkv`
Total: 0 B, Transferred: 11.00 KiB, Speed: 632.68 KiB/s
Files are sent into bucket named: 075fd0a3-7331-4f63-97ca-faccf3057b4c
```



## TODO list
- [x] rendering in docker container with Ubuntu for multiple frames on CPUs
- [ ] rendering on GPUs
- [ ] rendering in kubernetes orchestrator
- [ ] add monitoring/observability for rendering proces for long/huge arts Blender's files
- [ ] share the knowledge/experiences with community (maybe YT movie about it)

