#!/bin/sh
#$ -cwd
#$ -V

## Join the standard error and the standard output into 1 file output
#$ -j y
#$ -q smurf.q
#$ -pe smp 12

#command
cd /home/daniele/gensim/mallet-2.0.8RC3/
export _JAVA_OPTIONS=-Xmx125g
bin/mallet train-topics --input /home/daniele/gensim/6_mers/corpus.mallet --output-state /home/daniele/gensim/6_mers/15t/6mers_state.gz --inferencer-filename /home/daniele/gensim/6_mers/15t/6mers_inferencer.mallet --evaluator-filename /home/daniele/gensim/6_mers/15t/6mers_evaluator.mallet --output-topic-keys /home/daniele/gensim/6_mers/15t/6mers_topickeys.txt --topic-word-weights-file /home/daniele/gensim/6_mers/15t/6mers_topicwordweights.txt --word-topic-counts-file /home/daniele/gensim/6_mers/15t/6mers_topicwordcounts.txt --diagnostics-file /home/daniele/gensim/6_mers/15t/6mers_diagnostics.xml --output-topic-docs /home/daniele/gensim/6_mers/15t/6mers_topicsdoc.txt --output-doc-topics /home/daniele/gensim/6_mers/15t/6mers_doctopics.txt --num-topics 15 --num-threads 12 --use-symmetric-alpha true --alpha 50
bin/mallet evaluate-topics --input /home/daniele/gensim/6_mers/testcorpus.mallet --evaluator /home/daniele/gensim/6_mers/15t/6mers_evaluator.mallet --output-doc-probs /home/daniele/gensim/6_mers/15t/6mers_docprobs.txt --output-prob /home/daniele/gensim/6_mers/15t/6mers_prob.txt
bin/mallet infer-topics --inferencer /home/daniele/gensim/6_mers/15t/6mers_inferencer.mallet --input /home/daniele/gensim/6_mers/testcorpus.mallet --output-doc-topics /home/daniele/gensim/6_mers/15t/6mers_doctopics_test.txt
#5 topics
bin/mallet train-topics --input /home/daniele/gensim/6_mers/corpus.mallet --output-state /home/daniele/gensim/6_mers/5t/6mers_state.gz --inferencer-filename /home/daniele/gensim/6_mers/5t/6mers_inferencer.mallet --evaluator-filename /home/daniele/gensim/6_mers/5t/6mers_evaluator.mallet --output-topic-keys /home/daniele/gensim/6_mers/5t/6mers_topickeys.txt --topic-word-weights-file /home/daniele/gensim/6_mers/5t/6mers_topicwordweights.txt --word-topic-counts-file /home/daniele/gensim/6_mers/5t/6mers_topicwordcounts.txt --diagnostics-file /home/daniele/gensim/6_mers/5t/6mers_diagnostics.xml --output-topic-docs /home/daniele/gensim/6_mers/5t/6mers_topicsdoc.txt --output-doc-topics /home/daniele/gensim/6_mers/5t/6mers_doctopics.txt --num-topics 5 --num-threads 12 --use-symmetric-alpha true --alpha 50
bin/mallet evaluate-topics --input /home/daniele/gensim/6_mers/testcorpus.mallet --evaluator /home/daniele/gensim/6_mers/5t/6mers_evaluator.mallet --output-doc-probs /home/daniele/gensim/6_mers/5t/6mers_docprobs.txt --output-prob /home/daniele/gensim/6_mers/5t/6mers_prob.txt
bin/mallet infer-topics --inferencer /home/daniele/gensim/6_mers/5t/6mers_inferencer.mallet --input /home/daniele/gensim/6_mers/testcorpus.mallet --output-doc-topics /home/daniele/gensim/6_mers/5t/6mers_doctopics_test.txt
#10 topics
bin/mallet train-topics --input /home/daniele/gensim/6_mers/corpus.mallet --output-state /home/daniele/gensim/6_mers/10t/6mers_state.gz --inferencer-filename /home/daniele/gensim/6_mers/10t/6mers_inferencer.mallet --evaluator-filename /home/daniele/gensim/6_mers/10t/6mers_evaluator.mallet --output-topic-keys /home/daniele/gensim/6_mers/10t/6mers_topickeys.txt --topic-word-weights-file /home/daniele/gensim/6_mers/10t/6mers_topicwordweights.txt --word-topic-counts-file /home/daniele/gensim/6_mers/10t/6mers_topicwordcounts.txt --diagnostics-file /home/daniele/gensim/6_mers/10t/6mers_diagnostics.xml --output-topic-docs /home/daniele/gensim/6_mers/10t/6mers_topicsdoc.txt --output-doc-topics /home/daniele/gensim/6_mers/10t/6mers_doctopics.txt --num-topics 10 --num-threads 12 --use-symmetric-alpha true --alpha 50
bin/mallet evaluate-topics --input /home/daniele/gensim/6_mers/testcorpus.mallet --evaluator /home/daniele/gensim/6_mers/10t/6mers_evaluator.mallet --output-doc-probs /home/daniele/gensim/6_mers/10t/6mers_docprobs.txt --output-prob /home/daniele/gensim/6_mers/10t/6mers_prob.txt
bin/mallet infer-topics --inferencer /home/daniele/gensim/6_mers/10t/6mers_inferencer.mallet --input /home/daniele/gensim/6_mers/testcorpus.mallet --output-doc-topics /home/daniele/gensim/6_mers/10t/6mers_doctopics_test.txt
#19 topics
bin/mallet train-topics --input /home/daniele/gensim/6_mers/corpus.mallet --output-state /home/daniele/gensim/6_mers/19t/6mers_state.gz --inferencer-filename /home/daniele/gensim/6_mers/19t/6mers_inferencer.mallet --evaluator-filename /home/daniele/gensim/6_mers/19t/6mers_evaluator.mallet --output-topic-keys /home/daniele/gensim/6_mers/19t/6mers_topickeys.txt --topic-word-weights-file /home/daniele/gensim/6_mers/19t/6mers_topicwordweights.txt --word-topic-counts-file /home/daniele/gensim/6_mers/19t/6mers_topicwordcounts.txt --diagnostics-file /home/daniele/gensim/6_mers/19t/6mers_diagnostics.xml --output-topic-docs /home/daniele/gensim/6_mers/19t/6mers_topicsdoc.txt --output-doc-topics /home/daniele/gensim/6_mers/19t/6mers_doctopics.txt --num-topics 19 --num-threads 12 --use-symmetric-alpha true --alpha 50
bin/mallet evaluate-topics --input /home/daniele/gensim/6_mers/testcorpus.mallet --evaluator /home/daniele/gensim/6_mers/19t/6mers_evaluator.mallet --output-doc-probs /home/daniele/gensim/6_mers/19t/6mers_docprobs.txt --output-prob /home/daniele/gensim/6_mers/19t/6mers_prob.txt
bin/mallet infer-topics --inferencer /home/daniele/gensim/6_mers/19t/6mers_inferencer.mallet --input /home/daniele/gensim/6_mers/testcorpus.mallet --output-doc-topics /home/daniele/gensim/6_mers/19t/6mers_doctopics_test.txt

