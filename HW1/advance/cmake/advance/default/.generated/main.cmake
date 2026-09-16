include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(advance_default_library_list )

# Handle files with suffix (s|S|asm|ASM|msa|MSA), for group default-PIC-AS
if(advance_default_default_PIC_AS_FILE_TYPE_assemble)
add_library(advance_default_default_PIC_AS_assemble OBJECT ${advance_default_default_PIC_AS_FILE_TYPE_assemble})
    advance_default_default_PIC_AS_assemble_rule(advance_default_default_PIC_AS_assemble)
    list(APPEND advance_default_library_list "$<TARGET_OBJECTS:advance_default_default_PIC_AS_assemble>")

endif()


# Main target for this project
add_executable(advance_default_image_IKm_teux ${advance_default_library_list})

set_target_properties(advance_default_image_IKm_teux PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${advance_default_output_dir}")
target_link_libraries(advance_default_image_IKm_teux PRIVATE ${advance_default_default_PIC_AS_FILE_TYPE_link})
# Add the link options from the rule file.
advance_default_link_rule( advance_default_image_IKm_teux)



