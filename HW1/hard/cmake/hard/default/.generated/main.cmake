include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(hard_default_library_list )

# Handle files with suffix (s|S|asm|ASM|msa|MSA), for group default-PIC-AS
if(hard_default_default_PIC_AS_FILE_TYPE_assemble)
add_library(hard_default_default_PIC_AS_assemble OBJECT ${hard_default_default_PIC_AS_FILE_TYPE_assemble})
    hard_default_default_PIC_AS_assemble_rule(hard_default_default_PIC_AS_assemble)
    list(APPEND hard_default_library_list "$<TARGET_OBJECTS:hard_default_default_PIC_AS_assemble>")

endif()


# Main target for this project
add_executable(hard_default_image_4FlGuWsE ${hard_default_library_list})

set_target_properties(hard_default_image_4FlGuWsE PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${hard_default_output_dir}")
target_link_libraries(hard_default_image_4FlGuWsE PRIVATE ${hard_default_default_PIC_AS_FILE_TYPE_link})
# Add the link options from the rule file.
hard_default_link_rule( hard_default_image_4FlGuWsE)



