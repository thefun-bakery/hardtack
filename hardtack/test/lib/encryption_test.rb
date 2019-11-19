require 'encryption'

class EncryptionTest < ActiveSupport::TestCase
  test "encrypt decrypt" do
    val = "test"
    encrypted_val = Encryption.encrypt(val)
    decrypted_val = Encryption.decrypt(encrypted_val)

    assert val == decrypted_val
  end
end
