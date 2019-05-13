FROM m5182107/ubuntu-18.04_pcl-1.9.1

MAINTAINER Shoma Kiura <m5182107.s@gmail.com>

RUN apt update && apt install -y --no-install-recommends \
    libusb-1.0.0-dev \
    libyaml-cpp-dev \
    libglfw3-dev \
    libgtk-3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    && apt clean

# Build fmt 5.3.0
RUN git clone -b 5.3.0 --depth 1 https://github.com/fmtlib/fmt.git fmt \
    && cd fmt \
    && mkdir build&& cd build \
    && cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=ON .. \
    && ninja && ninja install && ninja clean \
    && ldconfig \
    && cd / && rm -rf /fmt

# Build librealsense2.16.1
RUN git clone -b v2.16.1 --depth 1 https://github.com/IntelRealSense/librealsense.git librealsense2 \
    && cd librealsense2 \
    && mkdir build && cd build \
    && cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ .. \
    && ninja && ninja install && ninja clean \
    && ldconfig \
    && cd / && rm -rf /librealsense2

# Build opencv 3.4.6
RUN git clone -b 3.4.6 --depth 1 https://github.com/opencv/opencv.git opencv \
    && git clone -b 3.4.6 --depth 1 https://github.com/opencv/opencv_contrib.git opencv_contrib \
    && cd opencv \
    && mkdir build && cd build \
    && cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules .. \
    && ninja && ninja install && ninja clean \
    && ldconfig \
    && cd / && rm -rf /opencv /opencv_contrib

# fix c++ include library
RUN sed -i -e "45 s/#include_next/#include/g" /usr/include/c++/7.4.0/cmath \
    && sed -i -e "38 s/#include_next/#include/g" /usr/include/c++/7.4.0/bits/std_abs.h \
    && sed -i -e "75 s/#include_next/#include/g" /usr/include/c++/7.4.0/cstdlib
