include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(HW5_1_default_library_list )

# Handle files with suffix (s|as|asm|AS|ASM|As|aS|Asm), for group default-XC8
if(HW5_1_default_default_XC8_FILE_TYPE_assemble)
add_library(HW5_1_default_default_XC8_assemble OBJECT ${HW5_1_default_default_XC8_FILE_TYPE_assemble})
    HW5_1_default_default_XC8_assemble_rule(HW5_1_default_default_XC8_assemble)
    list(APPEND HW5_1_default_library_list "$<TARGET_OBJECTS:HW5_1_default_default_XC8_assemble>")

endif()

# Handle files with suffix S, for group default-XC8
if(HW5_1_default_default_XC8_FILE_TYPE_assemblePreprocess)
add_library(HW5_1_default_default_XC8_assemblePreprocess OBJECT ${HW5_1_default_default_XC8_FILE_TYPE_assemblePreprocess})
    HW5_1_default_default_XC8_assemblePreprocess_rule(HW5_1_default_default_XC8_assemblePreprocess)
    list(APPEND HW5_1_default_library_list "$<TARGET_OBJECTS:HW5_1_default_default_XC8_assemblePreprocess>")

endif()

# Handle files with suffix [cC], for group default-XC8
if(HW5_1_default_default_XC8_FILE_TYPE_compile)
add_library(HW5_1_default_default_XC8_compile OBJECT ${HW5_1_default_default_XC8_FILE_TYPE_compile})
    HW5_1_default_default_XC8_compile_rule(HW5_1_default_default_XC8_compile)
    list(APPEND HW5_1_default_library_list "$<TARGET_OBJECTS:HW5_1_default_default_XC8_compile>")

endif()

# Handle files with suffix elf, for group default-XC8
if(HW5_1_default_default_XC8_FILE_TYPE_objcopy_lss)
add_library(HW5_1_default_default_XC8_objcopy_lss OBJECT ${HW5_1_default_default_XC8_FILE_TYPE_objcopy_lss})
    HW5_1_default_default_XC8_objcopy_lss_rule(HW5_1_default_default_XC8_objcopy_lss)
    list(APPEND HW5_1_default_library_list "$<TARGET_OBJECTS:HW5_1_default_default_XC8_objcopy_lss>")

endif()


# Main target for this project
add_executable(HW5_1_default_image_TLWjZi6Y ${HW5_1_default_library_list})

set_target_properties(HW5_1_default_image_TLWjZi6Y PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    ADDITIONAL_CLEAN_FILES "${output_extensions}"
    RUNTIME_OUTPUT_DIRECTORY "${HW5_1_default_output_dir}")
target_link_libraries(HW5_1_default_image_TLWjZi6Y PRIVATE ${HW5_1_default_default_XC8_FILE_TYPE_link})
# Add the link options from the rule file.
HW5_1_default_link_rule( HW5_1_default_image_TLWjZi6Y)


#Add objcopy steps
HW5_1_default_objcopy_lss_rule(HW5_1_default_image_TLWjZi6Y)

