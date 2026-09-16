include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(basic_default_library_list )

# Handle files with suffix (s|S|asm|ASM|msa|MSA), for group default-PIC-AS
if(basic_default_default_PIC_AS_FILE_TYPE_assemble)
add_library(basic_default_default_PIC_AS_assemble OBJECT ${basic_default_default_PIC_AS_FILE_TYPE_assemble})
    basic_default_default_PIC_AS_assemble_rule(basic_default_default_PIC_AS_assemble)
    list(APPEND basic_default_library_list "$<TARGET_OBJECTS:basic_default_default_PIC_AS_assemble>")

endif()


# Main target for this project
add_executable(basic_default_image_xsYY7mew ${basic_default_library_list})

set_target_properties(basic_default_image_xsYY7mew PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${basic_default_output_dir}")
target_link_libraries(basic_default_image_xsYY7mew PRIVATE ${basic_default_default_PIC_AS_FILE_TYPE_link})
# Add the link options from the rule file.
basic_default_link_rule( basic_default_image_xsYY7mew)



