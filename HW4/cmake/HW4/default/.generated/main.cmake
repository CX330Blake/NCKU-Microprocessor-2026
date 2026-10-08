include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(HW4_default_library_list )

# Handle files with suffix (s|S|asm|ASM|msa|MSA), for group default-PIC-AS
if(HW4_default_default_PIC_AS_FILE_TYPE_assemble)
add_library(HW4_default_default_PIC_AS_assemble OBJECT ${HW4_default_default_PIC_AS_FILE_TYPE_assemble})
    HW4_default_default_PIC_AS_assemble_rule(HW4_default_default_PIC_AS_assemble)
    list(APPEND HW4_default_library_list "$<TARGET_OBJECTS:HW4_default_default_PIC_AS_assemble>")

endif()


# Main target for this project
add_executable(HW4_default_image_0BjC8NBF ${HW4_default_library_list})

set_target_properties(HW4_default_image_0BjC8NBF PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${HW4_default_output_dir}")
target_link_libraries(HW4_default_image_0BjC8NBF PRIVATE ${HW4_default_default_PIC_AS_FILE_TYPE_link})
# Add the link options from the rule file.
HW4_default_link_rule( HW4_default_image_0BjC8NBF)



