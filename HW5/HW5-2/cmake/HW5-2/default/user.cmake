# Include the assembly source before MPLAB regenerates its source-file list.
if(NOT TARGET HW5_2_default_default_XC8_assemblePreprocess)
    add_library(HW5_2_default_default_XC8_assemblePreprocess OBJECT
        "${CMAKE_CURRENT_LIST_DIR}/../../../count_primes.S")
    HW5_2_default_default_XC8_assemblePreprocess_rule(
        HW5_2_default_default_XC8_assemblePreprocess)
    target_sources(HW5_2_default_image_cPmw22_L PRIVATE
        $<TARGET_OBJECTS:HW5_2_default_default_XC8_assemblePreprocess>)
endif()
