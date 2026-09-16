# The following functions contains all the flags passed to the different build stages.

set(PACK_REPO_PATH "/Users/CX330/.mchp_packs" CACHE PATH "Path to the root of a pack repository.")

function(advance_default_default_PIC_AS_assemble_rule target)
    set(options
        "-mcpu=18F4520"
        "-c"
        "-misa=std"
        "-fmax-errors=20"
        "-mwarn=0"
        "-xassembler-with-cpp"
        "-mdfp=${PACK_REPO_PATH}/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8")
    list(REMOVE_ITEM options "")
    target_compile_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target} PRIVATE "__DEBUG=1")
endfunction()
function(advance_default_link_rule target)
    set(options
        "-mcpu=18F4520"
        "-c"
        "-misa=std"
        "-mcallgraph=std"
        "-mno-download-hex"
        "-mdfp=${PACK_REPO_PATH}/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8")
    list(REMOVE_ITEM options "")
    target_link_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target} PRIVATE "__DEBUG=1")
endfunction()
