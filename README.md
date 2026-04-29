<pre>
       ___      .______      ______   __    __  .______
      /   \     |   _  \    /      | |  |  |  | |   _  \
     /  ^  \    |  |_)  |  |  ,----' |  |__|  | |  |_)  |
    /  /_\  \   |      /   |  |      |   __   | |      /
   /  _____  \  |  |\  \_. |  `----. |  |  |  | |  |\  \_.
  /__/     \__\ | _| `.__|  \______| |__|  |__| | _| `.__|

  https://github.com/ycl6/ArchR
</pre>

[![Lifecycle: Experimental](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

Thanks for visiting this repository. If you are looking for the *official* ArchR package maintained by the Greenleaf Lab @ Stanford, please visit: https://github.com/GreenleafLab/ArchR

The ArchR package available here branched off from ArchR version 1.0.3 (commit [6feec35](https://github.com/ycl6/ArchR/commit/6feec354ad6c8052ddbc4626a2ca2d858ed465bf)), it contains improvements and bug fixes. You can see the commit history [here](https://github.com/ycl6/ArchR/commits/devel/).

It has been tested in R version 4.5.3 and works with dependant packages from Bioconductor version 3.22.

## Installation

The package is available only on [GitHub](https://github.com/ycl6/ArchR), please use `devtools::install_github` or `remotes::install_github` function to install it.

For example:

``` r
# First, add Bioconductor repositories to the 'repos' option
options(repos = BiocManager::repositories())

# Use 'remotes' package to install scRUtils
remotes::install_github("ycl6/ArchR", ref="devel")
```

Then install other dependencies:

```r
library(ArchR)
ArchR::installExtraPackages()
```

## Load package

To use `ArchR` in a R session, load it using the `library()` command.

``` r
library(ArchR)
```

## Usage

There is currently no dedicated tutorial for this version of ArchR.
Please use `?somefunction` or `help("somefunction")` to see the update-to-date documentation on the use of functions and argument list.

## Useful links

- Official ArchR website: https://www.archrproject.com/
- Full manual of official ArchR: https://www.archrproject.com/bookdown
- Example 10x Multiome PBMCs analysis: https://greenleaflab.github.io/ArchR_2020/Ex-Analyze-Multiome.html
- Example Trajectory analysis: https://greenleaflab.github.io/ArchR_2020/Ex-Analyze-Trajectory.html
- Technical Report: [ArchR is a scalable software package for integrative single-cell chromatin accessibility analysis. Nat Genet 53, 403411 (2021)](https://doi.org/10.1038/s41588-021-00790-6)

