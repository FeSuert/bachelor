use anchor_lang::prelude::*;
use pyth_client::{self, Price, PriceStatus};

declare_id!("F1234567890123456789012345678901234567890");

#[error_code]
pub enum ErrorCode {
    #[msg("Invalid Pyth price configuration or status.")]
    InvalidPythConfig,
}

#[program]
pub mod pyth_oracle_check {
    use super::*;

    // Function to get and validate the price from a Pyth oracle
    pub fn get_valid_pyth_price(ctx: Context<GetPythPrice>) -> Result<u64> {
        let pyth_price_account_info = &ctx.accounts.pyth_price_account;
        let pyth_price_data = pyth_price_account_info.try_borrow_data()?;
        let pyth_price: Price = *pyth_client::cast::<Price>(&pyth_price_data);

        // Check if the Pyth price status is valid (i.e., in 'Trading' status)
        if pyth_price.agg.status != PriceStatus::Trading {
            return Err(error!(ErrorCode::InvalidPythConfig));
        }

        // Assuming the price is valid, proceed with your logic here
        // For example, return the current price:
        Ok(pyth_price.agg.price as u64)
    }
}

// #[derive(Accounts)]
// pub struct GetPythPrice<'info> {
//     #[account]
//     pub pyth_price_account: AccountInfo<'info>,
// }

// Recommendation:
// if let COption::Some(authority) = new_authority {
//     account.owner = authority;
// } else {
//     return Err(TokenError::InvalidInstruction.into());
// }

// account.delegate = COption::None;
// account.delegated_amount = 0;

// if account.is_native() {
//     account.close_authority = COption::None;
// }