
# Menu Driven Product Ordering System using 8086 Assembly

## About the Project

This project is a menu-driven product ordering system developed using **8086 Assembly Language**. It runs in DOS text mode and simulates a simple online store. Users can browse products, select items, add them to a shopping cart, remove items, view the cart, and generate a bill.

The project demonstrates the use of 8086 instructions, registers, memory tables, procedures, and DOS input/output services.

## Features

- Menu-based product selection.
- Add products to the shopping cart.
- Update quantities when an existing product is selected again.
- Remove a selected quantity or an entire cart item.
- Display cart items, quantities, individual costs, and the total.
- Generate a bill and clear the cart after billing.
- Input validation for invalid product choices and quantities.
- Cart capacity of up to 6 different product lines and 20 units in total.
- Product quantity selection from 1 to 9 per order.

## Technologies Used

- **Programming Language:** 8086 Assembly Language
- **Editor / Assembler / Emulator:** EMU8086
- **Execution Environment:** DOS Text Mode
- **Input / Output:** DOS Interrupt 21h

## How It Works

1. The program displays the online store banner, shopping cart, and main menu.
2. The user selects a category to view its products and prices.
3. The user chooses a product and enters a quantity between 1 and 9.
4. The selected product is added to the cart. If it is already present, its quantity is increased.
5. Users can view the cart and remove part or all of a cart item.
6. The bill option displays each cart item's cost and the grand total.
7. After the bill is displayed, the cart is cleared. The user can choose 0 to exit.

## Main Menu Options

| Option | Action |
|---|---|
| 1–5 | Open the corresponding product category |
| 6 | Remove an item from the cart |
| 7 | Show the bill |
| 0 | Exit the program |

## Implementation Details

- Product names are stored as strings in the data section.
- Product names are accessed through an offset table (`p_names`).
- Product prices are stored as word values in `p_price`.
- Category names, starting product indexes, and product counts are stored in tables.
- The cart uses arrays to store product indexes and quantities.
- Procedures are used for displaying categories, showing products, adding and removing cart items, listing the cart, and generating the bill.
- The `say` and `putch` macros simplify string and character output.
- DOS Interrupt 21h is used for keyboard input and screen output.

## How to Run

1. Install and open **EMU8086**.
2. Open the `mycode.asm` file in EMU8086.
3. Compile the assembly source code.
4. Run it using the emulator.
5. Follow the on-screen menu and enter the requested options.

## Testing

The program can be tested by selecting products from different categories, adding the same product more than once, removing part or all of a cart item, and generating a bill. It also includes checks for invalid product selections and quantities outside the allowed range.

## Learning Outcomes

- Understanding basic 8086 Assembly Language programming.
- Working with registers and memory-resident data.
- Using arrays and offset tables.
- Organizing a program using procedures and macros.
- Performing arithmetic operations for quantity and price calculations.
- Using DOS Interrupt 21h for basic input and output.

## License

This project was developed for academic and educational purposes.
