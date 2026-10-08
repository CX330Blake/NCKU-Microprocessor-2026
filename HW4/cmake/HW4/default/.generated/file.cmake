# The following variables contains the files used by the different stages of the build process.
set(HW4_default_default_PIC_AS_FILE_TYPE_assemble "${CMAKE_CURRENT_SOURCE_DIR}/../../../hard.S")
set_source_files_properties(${HW4_default_default_PIC_AS_FILE_TYPE_assemble} PROPERTIES LANGUAGE ASM)

# For assembly files, add "." to the include path for each file so that .include with a relative path works
foreach(source_file ${HW4_default_default_PIC_AS_FILE_TYPE_assemble})
        set_source_files_properties(${source_file} PROPERTIES INCLUDE_DIRECTORIES "$<PATH:NORMAL_PATH,$<PATH:REMOVE_FILENAME,${source_file}>>")
endforeach()

set(HW4_default_default_PIC_AS_FILE_TYPE_link)
set(HW4_default_image_name "default.elf")
set(HW4_default_image_base_name "default")

# The output directory of the final image.
set(HW4_default_output_dir "${CMAKE_CURRENT_SOURCE_DIR}/../../../out/HW4")

# The full path to the final image.
set(HW4_default_full_path_to_image ${HW4_default_output_dir}/${HW4_default_image_name})
