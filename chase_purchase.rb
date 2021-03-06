require 'csv'
require_relative 'searchable_transaction.rb'

class ChasePurchase
  # Constructor is private - only can be called by factory method
  private_class_method :new
  def initialize(chase_cc_last_four, file_line_index, transaction_date, description, chase_category, amount)
    @file_line_index = file_line_index
    @chase_cc_last_four = chase_cc_last_four
    @transaction_date = transaction_date
    @description = description
    @chase_category = chase_category
    @amount = amount
  end


  # params: row - CSV::Row
  # returns nilable ChasePurchase
  def self.from_csv_row(row, file_line_index, cc_last_four)
    transaction_date = 
      begin 
        Date.strptime(row[0], "%m/%d/%Y")
      rescue
        nil
      end
  
   
    description = row[2]
    chase_category = row[3]
    amount = row[5]

    return nil if row[4] != 'Sale'
    return nil if transaction_date.nil?
    return nil if description.nil?
    return nil if chase_category.nil?
    return nil if amount.nil?

    new(
      cc_last_four,
      file_line_index,
      transaction_date,
      description,
      chase_category,
      amount,
    )
  end

  def to_searchable_transaction(tags)
    SearchableTransaction.new(
      @file_line_index,
      @transaction_date,
      @description,
      @chase_category,
      @amount,
      tags,
    )
  end

  def to_pretty_string
    """
    Description: #{@description}
    Date: #{@transaction_date}
    Amount: #{@amount}
    """
  end
end 
