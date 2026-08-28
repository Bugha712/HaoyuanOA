<template>
  <el-row :gutter="20">
    <el-col :span="8">
      <el-form-item label="总分计算" :prop="`${propPrefix}scoreCalculation`">
        <el-select
          v-model="model.scoreCalculation"
          :disabled="disabled"
          class="!w-1/1"
          placeholder="请选择"
        >
          <el-option
            v-for="dict in getIntDictOptions(DICT_TYPE.HRM_PERFORMANCE_SCORE_CALCULATION)"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
    </el-col>
    <el-col :span="8">
      <el-form-item label="评分上限类型" :prop="`${propPrefix}upperLimitType`">
        <el-select
          v-model="model.upperLimitType"
          :disabled="disabled"
          class="!w-1/1"
          placeholder="请选择"
        >
          <el-option label="统一上限" :value="HrmPerformanceUpperLimitType.UNIFIED" />
        </el-select>
      </el-form-item>
    </el-col>
    <el-col :span="8">
      <el-form-item label="评分上限" :prop="`${propPrefix}upperLimitScore`">
        <el-input-number
          v-model="model.upperLimitScore"
          :disabled="disabled"
          :min="0"
          :precision="2"
          class="!w-1/1"
          placeholder="请输入评分上限"
        />
      </el-form-item>
    </el-col>
  </el-row>
  <el-alert
    class="mb-16px"
    :closable="false"
    type="info"
    show-icon
    title="总分 = 评分 × 维度权重 × 指标权重，再累加；维度权重合计须为 100%，不可编辑维度的指标权重合计须为 100%，可编辑维度不可超过 100%。"
  />
  <slot name="after-score-config"></slot>

  <template v-if="showDimensions">
    <div class="mb-12px flex items-center justify-between">
      <div>
        <span class="font-600">考核维度</span>
        <span class="ml-16px text-13px text-gray-500">
          当前维度权重合计：
          <span
            :class="
              !model.dimensions?.length
                ? 'text-gray-500'
                : isHundred(dimensionWeightTotal)
                  ? 'text-[var(--el-color-success)]'
                  : 'text-[var(--el-color-danger)]'
            "
          >
            {{ model.dimensions?.length ? `${dimensionWeightTotal}%` : '--' }}
          </span>
        </span>
      </div>
      <el-button :disabled="disabled" type="primary" @click="openDimensionForm()">
        <Icon icon="ep:plus" class="mr-5px" /> 新增考核维度
      </el-button>
    </div>

    <el-empty v-if="!model.dimensions?.length" :image-size="80" description="暂无考核维度" />
    <div
      v-for="(dimension, dimensionIndex) in model.dimensions"
      :key="dimensionIndex"
      class="mb-16px overflow-hidden border border-solid border-[var(--el-border-color)] rounded-4px"
    >
      <div
        class="flex items-center justify-between border-b border-b-solid border-b-[var(--el-border-color)] bg-[var(--el-fill-color-light)] px-16px py-12px"
      >
        <div>
          <div class="flex items-center gap-12px">
            <span class="font-600">{{ dimension.name }}</span>
            <el-tag effect="plain">{{ formatQuotaType(dimension.quotaType) }}</el-tag>
            <span class="text-13px">
              维度权重
              <span class="text-[var(--el-color-warning)]"> {{ dimension.weight || 0 }}% </span>
            </span>
            <el-tag v-if="dimension.allowEdit" effect="plain" type="success">允许员工填写</el-tag>
          </div>
          <div v-if="dimension.remark" class="mt-6px text-12px text-gray-500">
            {{ dimension.remark }}
          </div>
        </div>
        <div class="shrink-0">
          <el-button
            :disabled="disabled"
            link
            type="primary"
            @click="openDimensionForm(dimensionIndex)"
          >
            编辑
          </el-button>
          <el-button
            :disabled="disabled"
            link
            type="danger"
            @click="removeDimension(dimensionIndex)"
          >
            删除
          </el-button>
        </div>
      </div>
      <div class="p-16px">
        <div class="mb-12px flex items-center justify-between">
          <span class="text-13px text-gray-500">
            指标权重合计：
            <span
              :class="
                isHundred(getQuotaWeightTotal(dimension))
                  ? 'text-[var(--el-color-success)]'
                  : 'text-[var(--el-color-danger)]'
              "
            >
              {{ getQuotaWeightTotal(dimension) }}%
            </span>
          </span>
          <el-button :disabled="disabled" @click="addQuota(dimensionIndex)">
            <Icon icon="ep:plus" class="mr-5px" /> 新增指标项
          </el-button>
        </div>
        <el-table :data="dimension.quotas" border empty-text="暂无考核指标">
          <el-table-column label="指标名称" min-width="150">
            <template #default="scope">
              <el-input
                v-model="scope.row.name"
                :disabled="disabled"
                maxlength="50"
                placeholder="请输入指标名称"
              />
            </template>
          </el-table-column>
          <el-table-column label="指标说明" min-width="190">
            <template #default="scope">
              <el-input
                v-model="scope.row.illustrate"
                :autosize="{ minRows: 1, maxRows: 3 }"
                :disabled="disabled"
                maxlength="200"
                placeholder="请输入指标说明"
                resize="none"
                type="textarea"
              />
            </template>
          </el-table-column>
          <el-table-column label="考核标准" min-width="190">
            <template #default="scope">
              <el-input
                v-model="scope.row.standard"
                :autosize="{ minRows: 1, maxRows: 3 }"
                :disabled="disabled"
                maxlength="200"
                placeholder="请输入考核标准"
                resize="none"
                type="textarea"
              />
            </template>
          </el-table-column>
          <el-table-column label="指标权重" width="130">
            <template #default="scope">
              <div class="flex items-center gap-6px">
                <el-input-number
                  v-model="scope.row.weight"
                  :controls="false"
                  :disabled="disabled"
                  :max="100"
                  :min="0"
                  :precision="2"
                  class="!w-1/1"
                />
                <span class="text-gray-500">%</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="评分方式" width="130">
            <template #default="scope">
              <el-select v-model="scope.row.scoreType" :disabled="disabled" class="!w-1/1">
                <el-option label="直接输入" :value="HrmPerformanceQuotaScoreType.DIRECT_INPUT" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="80">
            <template #default="scope">
              <el-button
                :disabled="disabled"
                link
                type="danger"
                @click="removeQuota(dimensionIndex, scope.$index)"
              >
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
    <PerformanceAssessmentDimensionForm ref="dimensionFormRef" @confirm="handleDimensionConfirm" />
  </template>

  <div class="mt-24px">
    <div class="mb-12px flex items-center justify-between">
      <div>
        <span class="font-600">加减分项</span>
        <span class="ml-16px text-13px text-gray-500">
          评估流程完成后，在考核得分基础上按下列规则加减分
        </span>
      </div>
      <el-button :disabled="disabled" type="primary" @click="addBonusPenaltyItem">
        <Icon icon="ep:plus" class="mr-5px" /> 新增加减分项
      </el-button>
    </div>
    <el-empty
      v-if="!model.bonusPenaltyItems?.length"
      :image-size="60"
      description="暂无加减分项"
    />
    <el-table
      v-else
      :data="model.bonusPenaltyItems"
      border
      empty-text="暂无加减分项"
    >
      <el-table-column label="类型" width="90">
        <template #default="scope">
          <el-select v-model="scope.row.type" :disabled="disabled" class="!w-1/1">
            <el-option
              v-for="option in HrmPerformanceBonusPenaltyTypeOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </template>
      </el-table-column>
      <el-table-column label="名称" min-width="180">
        <template #default="scope">
          <el-input
            v-model="scope.row.name"
            :disabled="disabled"
            maxlength="50"
            placeholder="请输入加减分项名称"
          />
        </template>
      </el-table-column>
      <el-table-column label="分数范围" width="220">
        <template #default="scope">
          <div class="flex items-center gap-6px">
            <span class="w-16px text-14px">
              {{ scope.row.type === HrmPerformanceBonusPenaltyType.DEDUCT ? '-' : '+' }}
            </span>
            <el-input-number
              v-model="scope.row.minScore"
              :controls="false"
              :disabled="disabled"
              :min="0"
              :precision="0"
              class="!w-1/1"
              placeholder="最低分"
            />
            <span class="text-gray-500">~</span>
            <el-input-number
              v-model="scope.row.maxScore"
              :controls="false"
              :disabled="disabled"
              :min="0"
              :precision="0"
              class="!w-1/1"
              placeholder="最高分"
            />
          </div>
        </template>
      </el-table-column>
      <el-table-column label="备注" min-width="160">
        <template #default="scope">
          <el-input
            v-model="scope.row.remark"
            :disabled="disabled"
            maxlength="100"
            placeholder="请输入备注（可选）"
          />
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="80">
        <template #default="scope">
          <el-button
            :disabled="disabled"
            link
            type="danger"
            @click="removeBonusPenaltyItem(scope.$index)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script lang="ts" setup>
import type {
  AssessmentConfigVO,
  AssessmentDimensionVO
} from '@/api/hrm/performance/config/assessment-template'
import { DICT_TYPE, getIntDictOptions } from '@/utils/dict'
import {
  HrmPerformanceBonusPenaltyType,
  HrmPerformanceBonusPenaltyTypeOptions,
  HrmPerformanceQuotaScoreType,
  HrmPerformanceQuotaType,
  HrmPerformanceUpperLimitType
} from '@/views/hrm/utils/constants'
import {
  createDefaultBonusPenaltyItem,
  getQuotaWeightTotal,
  isHundred,
  validateAssessmentConfig
} from '@/views/hrm/utils/performance'
import PerformanceAssessmentDimensionForm from '../PerformanceAssessmentDimensionForm.vue'

defineOptions({ name: 'HrmPerformanceAssessmentConfigEditor' })

const props = withDefaults(
  defineProps<{
    disabled?: boolean
    propPrefix?: string
    showDimensions?: boolean
  }>(),
  {
    disabled: false,
    propPrefix: '',
    showDimensions: true
  }
)

const message = useMessage() // 消息弹窗
const model = defineModel<AssessmentConfigVO>({ required: true }) // 考核配置
const disabled = computed(() => props.disabled) // 是否禁用
const propPrefix = computed(() => props.propPrefix) // 校验字段前缀
const showDimensions = computed(() => props.showDimensions) // 是否展示维度
const dimensionFormRef = ref<InstanceType<typeof PerformanceAssessmentDimensionForm>>() // 维度表单 Ref
const currentDimensionIndex = ref<number>() // 当前维度下标
const dimensionWeightTotal = computed(() =>
  (model.value.dimensions || []).reduce(
    (total, dimension) => total + Number(dimension.weight || 0),
    0
  )
)

/** 校验考核配置 */
function validate() {
  const errorMessage = validateAssessmentConfig(model.value)
  if (errorMessage) {
    message.warning(errorMessage)
    return false
  }
  return true
}

/** 格式化指标类型 */
function formatQuotaType(quotaType?: number) {
  return quotaType === HrmPerformanceQuotaType.BEHAVIOR ? '行为态度指标' : '业绩指标'
}

/** 打开考核维度表单 */
function openDimensionForm(index?: number) {
  currentDimensionIndex.value = index
  dimensionFormRef.value?.open(index === undefined ? undefined : model.value.dimensions?.[index])
}

/** 保存考核维度 */
function handleDimensionConfirm(dimension: AssessmentDimensionVO) {
  model.value.dimensions ||= []
  if (currentDimensionIndex.value === undefined) {
    model.value.dimensions.push(dimension)
    return
  }
  model.value.dimensions.splice(currentDimensionIndex.value, 1, dimension)
}

/** 删除考核维度 */
function removeDimension(index: number) {
  model.value.dimensions?.splice(index, 1)
}

/** 添加考核指标 */
function addQuota(dimensionIndex: number) {
  const dimension = model.value.dimensions?.[dimensionIndex]
  if (!dimension) {
    return
  }
  dimension.quotas ||= []
  dimension.quotas.push({
    name: '',
    illustrate: '',
    standard: '',
    weight: undefined,
    scoreType: HrmPerformanceQuotaScoreType.DIRECT_INPUT
  })
}

/** 删除考核指标 */
function removeQuota(dimensionIndex: number, quotaIndex: number) {
  model.value.dimensions?.[dimensionIndex]?.quotas?.splice(quotaIndex, 1)
}

/** 新增加减分项 */
function addBonusPenaltyItem() {
  model.value.bonusPenaltyItems ||= []
  model.value.bonusPenaltyItems.push(createDefaultBonusPenaltyItem())
}

/** 删除加减分项 */
function removeBonusPenaltyItem(index: number) {
  model.value.bonusPenaltyItems?.splice(index, 1)
}

defineExpose({ validate }) // 提供 validate 方法，用于校验表单
</script>
