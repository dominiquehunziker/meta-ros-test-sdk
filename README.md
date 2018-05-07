### What ###

Test script for the SDK feature of meta-ros.


### How ###

Run the script `test-meta-ros-sdk.sh`. It will

  1) clone a minimal setup for meta-ros in the current directory;
  2) build a minimal image;
  3) build the corresponding SDK;
  4) build a docker image containing the installed SDK;
  5) use the SDK to build an executable and a library for the target system;
  6) run QEMU with the target system;
  7) build another executable on the target; and finally
  8) run a very simple pub/sub tests with the built ROS nodes.


### Notes ###

* The script requires access to the docker daemon, i.e., the script will attempt
  to run `docker run ...`, etc. as the current user.
* The script is not removing the built docker images; it is up to the user to
  clean up old images.
* In it's current form the script is not able to properly terminate QEMU, which
  has to be done manually for now.
