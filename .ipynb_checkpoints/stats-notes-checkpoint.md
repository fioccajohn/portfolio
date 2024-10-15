make a query file for the sql

open sql

run sql in bq

do something with the data

add a column

feed into the dashboard

# TODO
# Some of these should be special classes that can return values and analyses of input data for stats modeling in formats like statsmodels linear regression.
# Maybe covered by that pingouin package.
# What about just knowing stats well and using scipy and statsmodels?

import numpy as np

def stats():
    pass

1 What Is Statistics? 1
1.1 Introduction 1
1.2 Characterizing a Set of Measurements: Graphical Methods 3
1.3 Characterizing a Set of Measurements: Numerical Methods 8
1.4 How Inferences Are Made 13
1.5 Theory and Reality 14
1.6 Summary 15

2 Probability 20
2.1 Introduction 20
2.2 Probability and Inference 21
2.3 A Review of Set Notation 23
2.4 A Probabilistic Model for an Experiment: The Discrete Case 26
2.5 Calculating the Probability of an Event: The Sample-Point Method 2.6 Tools for Counting Sample Points 40
2.7 Conditional Probability and the Independence of Events 51
2.8 Two Laws of Probability 57
2.9 Calculating the Probability of an Event: The Event-Composition
Method 62
2.10 The Law of Total Probability and Bayes’ Rule 70
2.11 Numerical Events and Random Variables 75
2.12 Random Sampling 77
2.13 Summary 79

3 Discrete Random Variables and Their
Probability Distributions 86
3.1 Basic Definition 86
3.2 The Probability Distribution for a Discrete Random Variable 87
3.3 The Expected Value of a Random Variable or a Function
of a Random Variable 91
3.4 The Binomial Probability Distribution 100
3.5 The Geometric Probability Distribution 114
3.6 The Negative Binomial Probability Distribution (Optional) 121
3.7 The Hypergeometric Probability Distribution 125
3.8 The Poisson Probability Distribution 131
3.9 Moments and Moment-Generating Functions 138
3.10 Probability-Generating Functions (Optional) 143
3.11 Tchebysheff’s Theorem 146
3.12 Summary 149

4 Continuous Variables and Their Probability
Distributions 157
4.1 Introduction 157
4.2 The Probability Distribution for a Continuous Random Variable 4.3 Expected Values for Continuous Random Variables 170
4.4 The Uniform Probability Distribution 174
4.5 The Normal Probability Distribution 178
4.6 The Gamma Probability Distribution 185
4.7 The Beta Probability Distribution 194
4.8 Some General Comments 201
4.9 Other Expected Values 202
4.10 Tchebysheff’s Theorem 207
4.11 Expectations of Discontinuous Functions and Mixed Probability
Distributions (Optional) 210
4.12 Summary 214

5 Multivariate Probability Distributions 223
5.1 Introduction 223
5.2 Bivariate and Multivariate Probability Distributions 224
5.3 Marginal and Conditional Probability Distributions 235
5.4 Independent Random Variables 247
5.5 The Expected Value of a Function of Random Variables 5.6 Special Theorems 258
5.7 The Covariance of Two Random Variables 264
5.8 The Expected Value and Variance of Linear Functions
of Random Variables 270
5.9 The Multinomial Probability Distribution 279
5.10 The Bivariate Normal Distribution (Optional) 283
5.11 Conditional Expectations 285
5.12 Summary 290
255

6 Functions of Random Variables 296
6.1 Introduction 296
6.2 Finding the Probability Distribution of a Function
of Random Variables 297
6.3 The Method of Distribution Functions 298
6.4 The Method of Transformations 310
6.5 The Method of Moment-Generating Functions 318
6.6 Multivariable Transformations Using Jacobians (Optional) 325
6.7 Order Statistics 333
6.8 Summary 341

7 Sampling Distributions and the Central Limit Theorem 346
7.1 Introduction 346
7.2 Sampling Distributions Related to the Normal Distribution 353
7.3 The Central Limit Theorem 370
7.4 A Proof of the Central Limit Theorem (Optional) 377
7.5 The Normal Approximation to the Binomial Distribution 378
7.6 Summary 385

8 Estimation 390
8.1 Introduction 390
8.2 The Bias and Mean Square Error of Point Estimators 392
8.3 Some Common Unbiased Point Estimators 396
8.4 Evaluating the Goodness of a Point Estimator 399
8.5 Confidence Intervals 406
8.6 Large-Sample Confidence Intervals 411
8.7 Selecting the Sample Size 421
8.8 Small-Sample Confidence Intervals for μ and μ1− μ2 8.9 Confidence Intervals for σ 2 434
425
8.10 Summary 437

9 Properties of Point Estimators and Methods of Estimation 444
9.1 Introduction 444
9.2 Relative Efficiency 445
9.3 Consistency 448
9.4 Sufficiency 459
9.5 The Rao–Blackwell Theorem and Minimum-Variance
Unbiased Estimation 464
9.6 The Method of Moments 472
9.7 The Method of Maximum Likelihood 476
9.8 Some Large-Sample Properties of Maximum-Likelihood
Estimators (Optional) 483
9.9 Summary 485

10 Hypothesis Testing 488
10.1 Introduction 488
10.2 Elements of a Statistical Test 489
10.3 Common Large-Sample Tests 496
10.4 Calculating Type II Error Probabilities and Finding the Sample Size
for Z Tests 507
10.5 Relationships Between Hypothesis-Testing Procedures
and Confidence Intervals 511
10.6 Another Way to Report the Results of a Statistical Test:
Attained Significance Levels, or p-Values 513
10.7 Some Comments on the Theory of Hypothesis Testing 518
10.8 Small-Sample Hypothesis Testing for μ and μ1− μ2 520
10.9 Testing Hypotheses Concerning Variances 530
10.10 Power of Tests and the Neyman–Pearson Lemma 540
10.11 Likelihood Ratio Tests 549
10.12 Summary 556

11 Linear Models and Estimation by Least Squares 563
11.1 Introduction 564
11.2 Linear Statistical Models 566
11.3 The Method of Least Squares 569
11.4 Properties of the Least-Squares Estimators: Simple
Linear Regression 577
11.5 Inferences Concerning the Parameters βi 584
11.6 Inferences Concerning Linear Functions of the Model
Parameters: Simple Linear Regression 589
11.7 Predicting a Particular Value of Y by Using Simple Linear
Regression 593
11.8 Correlation 598
11.9 Some Practical Examples 604
11.10 Fitting the Linear Model by Using Matrices 609
11.11 Linear Functions of the Model Parameters: Multiple Linear
Regression 615
11.12 Inferences Concerning Linear Functions of the Model Parameters:
Multiple Linear Regression 616
11.13 Predicting a Particular Value of Y by Using Multiple Regression 622

11.14 A Test for H0 : βg+1 = βg+2 = · · · = βk = 0 624
11.15 Summary and Concluding Remarks 633

12 Considerations in Designing Experiments 640
12.1 The Elements Affecting the Information in a Sample 640
12.2 Designing Experiments to Increase Accuracy 641
12.3 The Matched-Pairs Experiment 644
12.4 Some Elementary Experimental Designs 651
12.5 Summary 657

13 The Analysis of Variance 661
13.1 Introduction 661
13.2 The Analysis of Variance Procedure 662
13.3 Comparison of More Than Two Means: Analysis of Variance
for a One-Way Layout 667
13.4 An Analysis of Variance Table for a One-Way Layout 671
13.5 A Statistical Model for the One-Way Layout 677
13.6 Proof of Additivity of the Sums of Squares and E(MST)
for a One-Way Layout (Optional) 679
13.7 Estimation in the One-Way Layout 681
13.8 A Statistical Model for the Randomized Block Design 686
13.9 The Analysis of Variance for a Randomized Block Design 688
13.10 Estimation in the Randomized Block Design 695
13.11 Selecting the Sample Size 696
13.12 Simultaneous Confidence Intervals for More Than One Parameter 698
13.13 Analysis of Variance Using Linear Models 701
13.14 Summary 705

14 Analysis of Categorical Data 713
14.1 A Description of the Experiment 713
14.2 The Chi-Square Test 714
14.3 A Test of a Hypothesis Concerning Specified Cell Probabilities: A Goodness-of-Fit Test 716
14.4 Contingency Tables 721
14.5 r × c Tables with Fixed Row or Column Totals 729
14.6 Other Applications 734
14.7 Summary and Concluding Remarks 736

15 Nonparametric Statistics 741
15.1 Introduction 741
15.2 A General Two-Sample Shift Model 742
15.3 The Sign Test for a Matched-Pairs Experiment 744
15.4 The Wilcoxon Signed-Rank Test for a Matched-Pairs Experiment 750
15.5 Using Ranks for Comparing Two Population Distributions: Independent Random Samples 755
15.6 The Mann–Whitney U Test: Independent Random Samples 758
15.7 The Kruskal–Wallis Test for the One-Way Layout 765
15.8 The Friedman Test for Randomized Block Designs 771
15.9 The Runs Test: A Test for Randomness 777
15.10 Rank Correlation Coefficient 783
15.11 Some General Comments on Nonparametric Statistical Tests 789

16 Introduction to Bayesian Methods for Inference 796
16.1 Introduction 796
16.2 Bayesian Priors, Posteriors, and Estimators 797
16.3 Bayesian Credible Intervals 808
16.4 Bayesian Tests of Hypotheses 813
16.5 Summary and Additional Comments 816
