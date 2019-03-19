FROM m5182107/ubuntu-18.04_pcl-1.9.1

MAINTAINER Shoma Kiura <m5182107.s@gmail.com>

RUN apt update && apt install -y --no-install-recommends \
    libopencv-dev \
    libusb-1.0.0-dev \
    libyaml-cpp-dev \
    libglfw3-dev \
    libssl-dev \
    libgtk-3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    xorg-dev \
    && apt clean

# Build fmt 5.3.0
RUN git clone -b 5.3.0 --depth 1 https://github.com/fmtlib/fmt.git fmt \
    && cd fmt \
    && mkdir build&& cd build \
    && cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ .. \
    && ninja && ninja install && ninja clean \
    && ldconfig \
    && cd / && rm -rf /fmt

# Build librealsense1.12.1
RUN git clone -b v1.12.1 --depth 1 https://github.com/IntelRealSense/librealsense.git librealsense1 \
    && cd librealsense1 \
    && mkdir build && cd build \
    && sed -i -e "25i #include <functional>" ../src/types.h \
    && cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ .. \
    && ninja && ninja install && ninja clean \
    && ldconfig \
    && cd / && rm -rf /librealsense1

# Build librealsense2.16.1
RUN git clone -b v2.16.1 --depth 1 https://github.com/IntelRealSense/librealsense.git librealsense2 \
    && cd librealsense2 \
    && mkdir build && cd build \
    && cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ .. \
    && ninja && ninja install && ninja clean \
    && ldconfig \
    && cd / && rm -rf /librealsense2

# fix c++ include library
RUN sed -i -e "45 s/#include_next/#include/g" /usr/include/c++/7.3.0/cmath \
    && sed -i -e "38 s/#include_next/#include/g" /usr/include/c++/7.3.0/bits/std_abs.h \
    && sed -i -e "75 s/#include_next/#include/g" /usr/include/c++/7.3.0/cstdlib
