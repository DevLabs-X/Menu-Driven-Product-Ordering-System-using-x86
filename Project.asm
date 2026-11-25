.model small
.stack 100h
say macro m
    mov dx, offset m
    call puts
endm
putch macro c
    mov dl, c
    call pchar
endm
.data
banner    db 13,10,'===== ONLINE PRODUCT STORE =====',13,10,'$'
nl_str    db 13,10,'$'
cat_hdr   db 13,10,'CATEGORIES:',13,10,'$'
menu_opts db '6. Remove item   7. Show bill   0. Exit',13,10,'Enter option: $'
cart_hdr  db 13,10,'--- YOUR CART ---',13,10,'$'
bill_hdr  db 13,10,'--- BILL ---',13,10,'$'
empty_msg db 'Cart is empty',13,10,'$'
tot_msg   db 'Total: $'
ask_prod  db 13,10,'Choose product (0 = back): $'
ask_qty   db 13,10,'Enter quantity (1-9): $'
ask_citem db 13,10,'Enter cart item number to remove (0 = cancel): $'
ask_rm1   db 13,10,'How many to remove (1-$'
ask_rm2   db '): $'
msg_added db 13,10,'Added to cart!',13,10,'$'
msg_removed db 13,10,'Removed from cart!',13,10,'$'
msg_bad   db 13,10,'Invalid input!',13,10,'$'
msg_limit db 13,10,'Cart limit reached (max 6 lines, 20 items)!',13,10,'$'
msg_thanks db 13,10,'Thank you for shopping! Cart cleared.',13,10,'$'
msg_bye   db 13,10,'Goodbye!',13,10,'$'
s_dash    db ' - $'
s_x       db ' x$'
s_eq      db ' = $'
cn1 db 'Mobiles$'
cn2 db 'Audio$'
cn3 db 'Laptops$'
cn4 db 'Wearables$'
cn5 db 'Tablets$'
cat_names dw cn1,cn2,cn3,cn4,cn5
cat_start db 0,2,5,7,9
cat_cnt   db 2,3,2,2,2
pn0 db 'Huawei P50 Pro$'
pn1 db 'BlackBerry KEY2$'
pn2 db 'Momentum 4 Headphones$'
pn3 db 'Sony WH-1000XM5$'
pn4 db 'Galaxy Buds Pro$'
pn5 db 'Asus ROG Zephyrus G14$'
pn6 db 'Dell XPS 13$'
pn7 db 'Apple Watch SE$'
pn8 db 'Fitbit Versa 4$'
pn9 db 'iPad Air$'
pn10 db 'Galaxy Tab S9$'
p_names dw pn0,pn1,pn2,pn3,pn4,pn5,pn6,pn7,pn8,pn9,pn10
p_price dw 899,549,379,399,199,1499,1299,249,199,599,799
cart_cnt  db 0
cart_prod db 6 dup(0)
cart_qty  db 6 dup(0)
units     db 0
total     dw 0
sel_prod  db 0
sel_qty   db 0
base_i    db 0
cnt_i     db 0
.code
main:
    mov ax, @data
    mov ds, ax
    say banner
main_loop:
    say cart_hdr
    call list_cart
    call print_cats
    say menu_opts
    call read_digit
    cmp al, 0
    je exit_prog
    cmp al, 5
    jbe do_cat
    cmp al, 6
    je do_remove
    cmp al, 7
    je do_bill
    say msg_bad
    jmp main_loop
do_cat:
    dec al
    xor bh, bh
    mov bl, al
    call show_products
    jmp main_loop
do_remove:
    call remove_item
    jmp main_loop
do_bill:
    call bill
    jmp main_loop
exit_prog:
    say msg_bye
    mov ax, 4C00h
    int 21h
show_products:
    say nl_str
    mov al, [cat_start+bx]
    mov [base_i], al
    mov al, [cat_cnt+bx]
    mov [cnt_i], al
    xor bx, bx
sp_list:
    call print_idx
    mov al, [base_i]
    add al, bl
    xor ah, ah
    mov si, ax
    shl si, 1
    mov dx, [p_names+si]
    call puts
    say s_dash
    putch '$'
    mov ax, [p_price+si]
    call print_num
    say nl_str
    inc bl
    cmp bl, [cnt_i]
    jb sp_list
    say ask_prod
    call read_digit
    cmp al, 0
    je sp_ret
    cmp al, [cnt_i]
    ja sp_bad
    dec al
    add al, [base_i]
    mov [sel_prod], al
    say ask_qty
    call read_digit
    cmp al, 1
    jb sp_bad
    cmp al, 9
    ja sp_bad
    mov [sel_qty], al
    add al, [units]
    cmp al, 20
    ja sp_limit
    call add_cart
    jc sp_limit
    say msg_added
    ret
sp_limit:
    say msg_limit
    ret
sp_bad:
    say msg_bad
sp_ret:
    ret
add_cart:
    mov al, [sel_prod]
    mov cl, [cart_cnt]
    xor ch, ch
    xor si, si
    jcxz ac_new
ac_s:
    cmp [cart_prod+si], al
    je ac_found
    inc si
    loop ac_s
ac_new:                         ; SI = cart_cnt here
    cmp byte ptr [cart_cnt], 6
    jae ac_full
    mov [cart_prod+si], al
    mov byte ptr [cart_qty+si], 0
    inc byte ptr [cart_cnt]
ac_found:
    mov dl, [sel_qty]
    add [cart_qty+si], dl
    add [units], dl
    clc
    ret
ac_full:
    stc
    ret
remove_item:
    cmp byte ptr [cart_cnt], 0
    jne ri_go
    say empty_msg
    ret
ri_go:
    say ask_citem
    call read_digit
    cmp al, 0
    je ri_ret
    cmp al, [cart_cnt]
    ja ri_bad
    dec al
    xor ah, ah
    mov bx, ax
    cmp byte ptr [cart_qty+bx], 1
    je ri_del
    say ask_rm1
    mov al, [cart_qty+bx]
    xor ah, ah
    call print_num
    say ask_rm2
    call read_digit
    cmp al, 1
    jb ri_bad
    cmp al, [cart_qty+bx]
    ja ri_bad
    je ri_del
    sub [cart_qty+bx], al
    sub [units], al
    jmp ri_done
ri_del:
    call remove_line
ri_done:
    say msg_removed
    ret
ri_bad:
    say msg_bad
ri_ret:
    ret
remove_line:
    mov al, [cart_qty+bx]
    sub [units], al
    dec byte ptr [cart_cnt]
rl_loop:
    cmp bl, [cart_cnt]
    jae rl_done
    mov al, [cart_prod+bx+1]
    mov [cart_prod+bx], al
    mov al, [cart_qty+bx+1]
    mov [cart_qty+bx], al
    inc bx
    jmp rl_loop
rl_done:
    ret
list_cart:
    mov word ptr [total], 0
    cmp byte ptr [cart_cnt], 0
    jne lc_go
    say empty_msg
    ret
lc_go:
    xor bx, bx
lc_loop:
    cmp bl, [cart_cnt]
    jae lc_total
    call print_idx
    mov al, [cart_prod+bx]
    xor ah, ah
    mov si, ax
    shl si, 1
    mov dx, [p_names+si]
    call puts
    say s_x
    mov al, [cart_qty+bx]
    xor ah, ah
    call print_num
    say s_eq
    putch '$'
    mov cl, [cart_qty+bx]
    xor ch, ch
    mov ax, [p_price+si]
    mul cx
    add [total], ax
    call print_num
    say nl_str
    inc bx
    jmp lc_loop
lc_total:
    say tot_msg
    mov ax, [total]
    call print_num
    say nl_str
    ret
bill:
    say bill_hdr
    call list_cart
    cmp byte ptr [cart_cnt], 0
    je bill_ret
    mov byte ptr [cart_cnt], 0
    mov byte ptr [units], 0
    say msg_thanks
bill_ret:
    ret
print_cats:
    say cat_hdr
    xor bx, bx
pc_loop:
    call print_idx
    mov si, bx
    shl si, 1
    mov dx, [cat_names+si]
    call puts
    say nl_str
    inc bx
    cmp bx, 5
    jb pc_loop
    ret
print_idx:
    mov dl, bl
    add dl, '1'
    call pchar
    putch '.'
    putch ' '
    ret
read_digit:
    mov ah, 1
    int 21h
    sub al, '0'
    ret
puts:
    mov ah, 9
    int 21h
    ret
pchar:
    mov ah, 2
    int 21h
    ret
print_num:
    push ax
    push bx
    push cx
    push dx
    mov bx, 10
    xor cx, cx
pn_div:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne pn_div
pn_out:
    pop dx
    add dl, '0'
    call pchar
    loop pn_out
    pop dx
    pop cx
    pop bx
    pop ax
    ret
end main