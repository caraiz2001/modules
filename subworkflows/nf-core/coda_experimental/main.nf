// include { PROPR_PROPR        } from '../../../modules/nf-core/propr/propr/main'
// include { PROPR_PROPD        } from '../../../modules/nf-core/propr/propd/main'
// include { PROPR_GREA         } from '../../../modules/nf-core/propr/grea/main'
// include { MYGENE             } from '../../../modules/nf-core/mygene/main'  
include { EXPERIMENTAL        } from './subworkflows/experimental/main.nf'
include { fromSamplesheet } from 'plugin/nf-validation'


Counts_ch = Channel.fromPath("../YMC/counts_sin0.csv")

Sample_ch = Channel.fromPath("../YMC/samplesheet_RCvsOX.csv")
  .map{ it -> [[id: 'YMC'], it]}

ch_samples_and_matrix = Sample_ch.combine(Counts_ch)

// Convertir la samplesheet.csv en un channel con el formato correcto
ch_tools = Channel.fromSamplesheet('tools')


if (params.pathway == "all") {
    ch_tools
        .set{ ch_tools_single }
} else {
    ch_tools
        .filter{
            it[0]["pathway_name"] == params.pathway
        }
        //.view()
        .set{ ch_tools_single }
}
ch_tools_single.view()

workflow {
    EXPERIMENTAL(ch_samples_and_matrix, ch_tools_single)
    EXPERIMENTAL.out.output.view()
}

