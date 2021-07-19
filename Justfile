all: deps dirs clone python configure build

deps:
	#!/bin/bash
	which apt
	which add-apt-repository
	wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
	source /etc/os-release
	echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
	sudo apt-get update
	sudo apt-get install -y build-essential clang-6.0 uuid-dev libz-dev libncurses5-dev libcurl4-openssl-dev mesa-common-dev libglu1-mesa-dev libjpeg-dev libjbig-dev libsdl2-dev libxcb-xinerama0 libxcb-xinput0 libfontconfig1-dev libopus-dev libwebp-dev

dirs:
	mkdir -p build o3de third-party install

clone:
	#!/bin/bash
	if git clone https://github.com/o3de/o3de; then
		echo "Cloned o3de"
	else
		cd o3de
		git pull
		echo "Updated o3de"
		cd ..
	fi

python:
	#!/bin/bash
	cd o3de
	./python/get_python.sh
	cd ..

configure:
	#!/bin/bash
	# Slightly modified version of https://github.com/o3de/o3de/issues/1900#issuecomment-875755078
	source configure.env
	# Run cmake configure
	cmake -B ${SCRIPT_DIR}/build/linux -S ${SCRIPT_DIR}/o3de -DLY_3RDPARTY_PATH=${LY_3RDPARTY_PATH} -DLY_PROJECTS="${LY_PROJECTS}" -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" "$@"

build:
	#!/bin/bash
	source configure.env
	cd build/linux
	make -j12 install
	cd ../../

tar:
	rm pkg.tar.gz || echo "No existing package to remove"
	tar -czf pkg.tar.gz install

clean:
	rm -rf install build third-party o3de pkg.tar.gz
