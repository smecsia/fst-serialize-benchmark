# Fast Serialization Benchmark

This project aims to compare the [Fast Serialization](https://github.com/RuedigerMoeller/fast-serialization) with
the standard one.

## How to launch

### 1. Clone this project
### 2. Install RVM:

```bash
\curl -L https://get.rvm.io | bash -s stable
. ~/.bashrc
```

If you are the Mac user, perhaps you will need to add theese lines into your .bashrc file manually:

```bash
if [[ -d "$HOME/.rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi
```

### 3. Install JRuby
```bash
rvm install jruby-1.7.4
rvm use jruby-1.7.4
```

### 4. Install jrmvnrunner
```bash
gem install jrmvnrunner
```
### 7. Run the benchmark with 1000 elements array and 10000 iterations
```bash
./run 1000 10000
```

That's it. You should see something like:
```bash
                      user     system      total        real
serialize           11.210000   0.050000  11.260000 ( 10.706000)
deserialize         15.450000   0.040000  15.490000 ( 14.629000)
serialize_fst       4.110000   0.010000   4.120000 (  3.790000)
deserialize_fst     4.240000   0.010000   4.250000 (  3.888000)
```
