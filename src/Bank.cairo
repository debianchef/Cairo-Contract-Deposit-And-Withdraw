use starknet::ContractAddress;

#[starknet::interface]
pub trait IBank<TState> {
    fn deposit(ref self: TState, amount: felt252);
  fn withdraw(ref self: TState, amount: felt252) -> felt252;
    fn get_balance(self: @TState) -> felt252;
}


#[starknet::contract]
 mod SimpleBank {
    #[storage]
    struct Storage {
        balance: felt252,
    }




    #[abi(embed_v0)]
    #[external(v0)]
     impl SimpleBank of super::IBank<ContractState> {
      
        // Increases the balance by the given amount.
        fn deposit(ref self: ContractState, amount: felt252) {
            self.balance.write(self.balance.read() + amount);
        }

 fn withdraw(ref self: ContractState, amount: felt252) -> felt252 {
            let current_balance = self.balance.read();
            self.balance.write(current_balance - amount);
            amount // Return the withdrawn amount
        }

        // Gets the balance.
        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}