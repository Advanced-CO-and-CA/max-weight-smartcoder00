/*************************************************************************************************
* file: Lab Assingment-3.s                                                                       *
* Author: Jethin Sekhar R (CS18M523)                                                             *
* Assembly code for Finding the 32-bit number that has the largest Weight                        *
*                   Using Brian Kernighan’s Algorithm                                            *
*************************************************************************************************/


@ bss section
    .bss

@ data section
    .data
    data_start:
                    .word 0x205a15e3                @(0010 0000 0101 1010 0001 0101 1101 0011 – 13)
                    .word 0x256c8700                @(0010 0101 0110 1100 1000 0111 0000 0000 – 11)
    data_end:       .word 0x295468f2                @(0010 1001 0101 0100 0110 1000 1111 0010 – 14)

    output_num:     .word 0                         @ Output Value
    output_weight:  .word 0                         @ Output Weight
    output_address: .word 0                         @ Output Address, An additional output

@ text section
      .text

temp                 .req r0                         @ Temporary Variable
current_address      .req r1                         @ Pointer to current Input Variable
end_address          .req r2                         @ Pointer to Last Input Variable
input_number         .req r3                         @ Local Variable for Reading Input Values
temp_weight          .req r4                         @ Temporary Variable to Calculate Weight
result_number        .req r5                         @ Temporary Variable to Store Result Value
result_weight        .req r6                         @ Temporary Variable to Store Max Weight
result_address       .req r7                         @ Temporary Variable to Store Results Address

.globl _main
    bl _main

/*** Function: calculate the weight *************************************************************/

get_weight:                                         @ Calculate weight and store in R4
    push {input_number, lr}
    mov  temp_weight, #0
    weight_loop:
        movs temp, input_number
        addne temp_weight, #1
        sub input_number, #1
        ands input_number, temp
        bne  weight_loop                            @ Continue if non zero
    pop  {input_number, pc}

/*** Function: update the results ***************************************************************/

update_results:                                     @ Update the Results in result variables
    push {lr}
    mov  result_number, input_number
    mov  result_weight, temp_weight
    mov  result_address, current_address
    pop  {pc}

/*** Function: store results ********************************************************************/

store_output:                                       @ Store Results in Output Variables
    push {lr}
    ldr  temp, =output_num
    str  result_number, [temp]
    ldr  temp, =output_weight
    str  result_weight, [temp]
    ldr  temp, =output_address
    str  result_address, [temp]
    pop  {pc}

/*** main Function ******************************************************************************/

_main:
    ldr  current_address, =data_start               @ Getting Start Address
    ldr  end_address, =data_end                     @ Getting End Address
    sub  current_address, #4                        @ Substracting Pointer by 4 for preindex
    mov  result_weight, #0                          @ Initializing Max Weight
    loop:
        ldr  input_number, [current_address, #4]!   @ load current number in input_number
        bl   get_weight                             @ Compute the Weight in temp_weight
        cmp  result_weight, temp_weight             @ Compare result_weight with temp_weight
        bllt update_results                         @ Update if temp_weight is greater
        cmp  current_address, end_address           @ Compare addresses
        bne  loop                                   @ Check if number reached end and continue
    bl   store_output                               @ Store the results
    .end

/*** End ****************************************************************************************/