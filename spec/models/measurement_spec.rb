require 'rails_helper'

# Test suite for the Item model
RSpec.describe Measurement, type: :model do
  # Association test
  # ensure an item record belongs to a single todo record
  it { should belong_to(:habit) }
  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:date) }
end
