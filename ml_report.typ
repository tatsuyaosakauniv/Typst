#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "Machine Learning",
  subtitle: "Titanic Survival Prediction with Feature Selection and a Frozen Neural Network",
  author: "Tatsuya Kawaguchi",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "bib\ml_report.bib",
)

= Feature Selection Method

In this project, only numerical features were used for training the model.
First, numerical columns were selected from the original CSV files, because neural networks cannot directly handle string or categorical values.

Some features contained missing values, so mean imputation was applied to fill NaN values.
After that, all features were standardized using StandardScaler to make them comparable.

Then, Principal Component Analysis (PCA) was applied to reduce the feature dimension to 5@Jolliffe2002.
The reason for choosing 5 components is that the pre-trained neural network requires a 5-dimensional input.

Relevant code blocks:

- Numerical feature selection

- Missing value imputation

- Standardization

- PCA with n_components=5

= Model Design

The model consists of two parts: a pre-trained neural network and an additional trainable classifier.

The pre-trained network was used as a feature extractor.
Its parameters were completely frozen to keep the learned representations unchanged@Bengio2013.

On top of the frozen network, a new classifier was added.
This classifier consists of two linear layers with a ReLU activation function in between and outputs a single value for classification.

Only the parameters of the added classifier were trained.
This design reduces the number of trainable parameters and helps prevent overfitting.

Relevant code blocks:

- Loading and freezing the pre-trained model

- Definition of the additional classifier layers

= results

The trained model was evaluated using the test dataset.
The evaluation results are shown below:

- Accuracy: 0.65

- Precision (macro): 0.26

- Recall (macro): 0.30

- F1-score (macro): 0.28

Because the target labels are multi-class, macro averaging was used for Precision, Recall, and F1-score@Fawcett2006.
A warning appeared indicating that some classes were not predicted by the model, which caused low precision values.

Relevant code block:

Evaluation using precision_recall_fscore_support with average="macro"

#pagebreak()

= Difficulties

Several difficulties were encountered during the implementation:

- Mismatch of feature dimensions between training and test data

- Errors caused by missing values when applying PCA

- Incorrect use of binary evaluation metrics for multi-class data

- Handling data conversion between Pandas, NumPy, and PyTorch

Especially, the order of preprocessing steps was important to avoid errors.

= Improvements and Considerations

The following points were considered in this implementation:

- Freezing the pre-trained model to preserve learned features

- Matching PCA output dimensions with the pre-trained model input

- Using macro-averaged metrics to fairly evaluate multi-class performance

- Saving the trained classifier weights for reuse

Overall, this project demonstrates a basic but practical approach to combining a pre-trained model with additional trainable layers.

\
