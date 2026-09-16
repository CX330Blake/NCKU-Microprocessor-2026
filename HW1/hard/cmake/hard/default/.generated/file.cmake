# The following variables contains the files used by the different stages of the build process.
set(hard_default_default_PIC_AS_FILE_TYPE_assemble "${CMAKE_CURRENT_SOURCE_DIR}/../../../main.S")
set_source_files_properties(${hard_default_default_PIC_AS_FILE_TYPE_assemble} PROPERTIES LANGUAGE ASM)

# For assembly files, add "." to the include path for each file so that .include with a relative path works
foreach(source_file ${hard_default_default_PIC_AS_FILE_TYPE_assemble})
        set_source_files_properties(${source_file} PROPERTIES INCLUDE_DIRECTORIES "$<PATH:NORMAL_PATH,$<PATH:REMOVE_FILENAME,${source_file}>>")
endforeach()

set(hard_default_default_PIC_AS_FILE_TYPE_link)
set(hard_default_image_name "default.elf")
set(hard_default_image_base_name "default")

# The output directory of the final image.
set(hard_default_output_dir "${CMAKE_CURRENT_SOURCE_DIR}/../../../out/hard")

# The full path to the final image.
set(hard_default_full_path_to_image ${hard_default_output_dir}/${hard_default_image_name})
