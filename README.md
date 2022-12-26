# returndatabomb-study
Repo dedicated to study and analyze the returndatabomb attack 


# Principle

Even if no data is retrieved while performing a low level call, `RETURNDATACOPY` is executed in the callers context wasting gas.


# References

- https://github.com/ethereum/solidity/issues/12306
- https://github.com/ethereum/solidity/issues/12647
