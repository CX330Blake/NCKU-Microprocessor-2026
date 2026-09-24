include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(HW2_default_library_list )

# Handle files with suffix (s|S|asm|ASM|msa|MSA), for group default-PIC-AS
if(HW2_default_default_PIC_AS_FILE_TYPE_assemble)
add_library(HW2_default_default_PIC_AS_assemble OBJECT ${HW2_default_default_PIC_AS_FILE_TYPE_assemble})
    HW2_default_default_PIC_AS_assemble_rule(HW2_default_default_PIC_AS_assemble)
    list(APPEND HW2_default_library_list "$<TARGET_OBJECTS:HW2_default_default_PIC_AS_assemble>")

endif()


# Main target for this project
add_executable(HW2_default_image_c2Gr8LZI ${HW2_default_library_list})

set_target_properties(HW2_default_image_c2Gr8LZI PROPERTIES
    OUTPUT_NAME "default-production"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${HW2_default_output_dir}")
target_link_libraries(HW2_default_image_c2Gr8LZI PRIVATE ${HW2_default_default_PIC_AS_FILE_TYPE_link})
# Add the link options from the rule file.
HW2_default_link_rule( HW2_default_image_c2Gr8LZI)



