#
# Copyright (C) 2022 UWings Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
$(call inherit-product, device/google_car/common/pre_google_car.mk)
$(call inherit-product, device/uwings/ok6254c/auto/device-car.mk)
$(call inherit-product, device/uwings/ok6254c/common/post_google_car.mk)

PRODUCT_PACKAGE_OVERLAYS := device/uwings/ok6254c/auto/overlay
$(call inherit-product, packages/services/Car/car_product/build/car.mk)

PRODUCT_NAME := ok6254c_car
PRODUCT_DEVICE := ok6254c
PRODUCT_BRAND := UWINGS
PRODUCT_MODEL := AOSP_Car_on_OK6254-C
PRODUCT_MANUFACTURER := Forlinx
