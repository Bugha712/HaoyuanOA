<template>
  <el-drawer v-model="drawerVisible" title="绩效评分" size="880px" destroy-on-close>
    <div v-loading="loading" class="min-w-0">
      <div class="mb-16px flex items-start justify-between gap-16px">
        <div>
          <div class="text-20px text-[var(--el-text-color-primary)] font-600">
            {{ detail.employeeName || '-' }}
          </div>
          <div class="mt-4px text-13px text-[var(--el-text-color-secondary)]">
            {{ detail.name || '-' }}
          </div>
        </div>
        <div class="flex items-center gap-8px whitespace-nowrap">
          <el-tag type="warning" effect="plain">{{ currentStage?.name || '待评分' }}</el-tag>
          <span>权重 {{ currentStage?.weight || 0 }}%</span>
        </div>
      </div>

      <div
        v-if="detail.reviewStages?.length"
        class="mb-16px border-t border-t-solid border-t-[var(--el-border-color-lighter)]"
      >
        <div
          v-for="stage in detail.reviewStages"
          :key="stage.id"
          class="min-h-52px grid grid-cols-[minmax(180px,1fr)_70px_80px_70px] items-center border-b border-b-solid border-b-[var(--el-border-color-lighter)]"
        >
          <div class="flex flex-col">
            <span>{{ stage.name }}</span>
            <span class="mt-4px text-13px text-[var(--el-text-color-secondary)]">
              {{ stage.handlerName || '-' }}
            </span>
          </div>
          <span>{{ stage.weight || 0 }}%</span>
          <el-tag
            v-if="stage.status === HrmPerformanceAssessmentStageStatus.PROCESSED"
            type="success"
            effect="plain"
          >
            已完成
          </el-tag>
          <el-tag
            v-else-if="stage.status === HrmPerformanceAssessmentStageStatus.PENDING"
            type="warning"
            effect="plain"
          >
            待评分
          </el-tag>
          <el-tag v-else type="info" effect="plain">未开始</el-tag>
          <span class="text-right">{{ stage.score ?? '-' }}</span>
        </div>
      </div>

      <el-alert
        v-if="currentStage?.rejectReason"
        class="mb-16px"
        :closable="false"
        type="warning"
        show-icon
        :title="`评分被驳回：${currentStage.rejectReason}`"
      />

      <div
        v-if="scorePreview"
        class="mb-16px min-h-48px flex items-center justify-between gap-20px border-y border-y-solid border-y-[var(--el-border-color-lighter)] py-8px"
        aria-live="polite"
      >
        <div class="flex items-center gap-8px">
          <span class="text-13px text-[var(--el-text-color-secondary)]">本阶段试算</span>
          <strong>{{ scorePreview.stageScore ?? '-' }} 分</strong>
          <el-tag v-if="scorePreview.stageResultLevel" size="small" effect="plain">
            {{ scorePreview.stageResultLevel }}
          </el-tag>
        </div>
        <div class="flex items-center gap-8px">
          <span class="text-13px text-[var(--el-text-color-secondary)]">当前累计分</span>
          <strong>{{ scorePreview.cumulativeScore ?? '-' }} 分</strong>
          <el-tag
            v-if="scorePreview.cumulativeResultLevel"
            size="small"
            type="success"
            effect="plain"
          >
            {{ scorePreview.cumulativeResultLevel }}
          </el-tag>
        </div>
        <div class="flex items-center gap-8px">
          <span class="text-13px text-[var(--el-text-color-secondary)]">加减分</span>
          <strong :class="(scorePreview.bonusPenaltySubtotal || 0) < 0 ? 'text-[var(--el-color-danger)]' : 'text-[var(--el-color-success)]'">
            {{ formatSignedScore(scorePreview.bonusPenaltySubtotal) }}
          </strong>
        </div>
        <div v-if="scorePreview.finalScorePreview !== null && scorePreview.finalScorePreview !== undefined" class="flex items-center gap-8px">
          <span class="text-13px text-[var(--el-text-color-secondary)]">最终得分</span>
          <strong>{{ scorePreview.finalScorePreview }} 分</strong>
        </div>
      </div>

      <el-alert
        class="mb-12px"
        :closable="false"
        type="info"
        show-icon
        :title="`单项评分范围为 0～${detail.upperLimitScore ?? '-'} 分，最多保留两位小数；总分按评分、维度权重和指标权重计算。`"
      />

      <el-table :data="detail.quotas || []" border>
        <el-table-column label="维度" prop="dimensionName" width="110" show-overflow-tooltip />
        <el-table-column label="指标" prop="name" min-width="145" show-overflow-tooltip />
        <el-table-column label="目标值" prop="targetValue" min-width="125" show-overflow-tooltip />
        <el-table-column label="实际值" min-width="125">
          <template #default="scope">
            <el-input v-model="scope.row.actualValue" maxlength="1000" placeholder="实际完成情况" />
          </template>
        </el-table-column>
        <el-table-column label="评分" width="110">
          <template #default="scope">
            <el-input-number
              v-model="scope.row.finalScore"
              :min="0"
              :max="detail.upperLimitScore"
              :precision="2"
              :controls="false"
              aria-label="指标评分"
              class="!w-1/1"
              @change="schedulePreview"
            />
          </template>
        </el-table-column>
        <el-table-column label="评语" min-width="160">
          <template #default="scope">
            <el-input v-model="scope.row.comment" maxlength="1000" placeholder="指标评语" />
          </template>
        </el-table-column>
      </el-table>

      <el-input
        v-model="stageComment"
        class="mt-16px"
        type="textarea"
        :rows="3"
        maxlength="2000"
        :placeholder="currentStage?.raterType === 4 ? '自评说明' : '评分说明'"
        show-word-limit
      />

      <div v-if="detail.bonusPenaltyItems?.length" class="mt-20px">
        <div class="mb-12px">
          <span class="font-600">加减分</span>
          <span class="ml-16px text-13px text-gray-500">
            评估流程完成后，在考核得分基础上按下列规则加减分（0 分表示不适用）
          </span>
        </div>
        <el-table
          :data="detail.bonusPenaltyItems"
          border
          empty-text="暂无加减分项"
        >
          <el-table-column label="类型" width="70">
            <template #default="scope">
              <el-tag :type="scope.row.type === HrmPerformanceBonusPenaltyType.DEDUCT ? 'danger' : 'success'" effect="plain">
                {{ scope.row.type === HrmPerformanceBonusPenaltyType.DEDUCT ? '减分' : '加分' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="名称" min-width="150">
            <template #default="scope">
              <div>{{ scope.row.name }}</div>
              <div v-if="scope.row.remark" class="mt-4px text-12px text-gray-500">
                {{ scope.row.remark }}
              </div>
            </template>
          </el-table-column>
          <el-table-column label="可加/减分数" width="140">
            <template #default="scope">
              <span class="text-13px">
                {{ scope.row.type === HrmPerformanceBonusPenaltyType.DEDUCT ? `-${scope.row.maxScore} ~ -${scope.row.minScore}` : `${scope.row.minScore} ~ ${scope.row.maxScore}` }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="本次分值" width="160">
            <template #default="scope">
              <el-input-number
                :model-value="proxyGetAbsScore(scope.$index)"
                :min="0"
                :max="Math.max(scope.row.maxScore || 0, 0)"
                :precision="1"
                :controls="false"
                class="!w-1/1"
                @update:model-value="proxySetScore(scope.$index, $event)"
                @change="schedulePreview"
              />
            </template>
          </el-table-column>
          <el-table-column label="加减分说明" min-width="180">
            <template #default="scope">
              <el-input
                :model-value="bonusRows[scope.$index]?.reason"
                maxlength="500"
                placeholder="请输入加减分说明（可选）"
                @update:model-value="(value: any) => (bonusRows[scope.$index]!.reason = value)"
              />
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>

    <template #footer>
      <el-button
        v-if="canReject"
        :loading="submitting"
        plain
        type="danger"
        @click="rejectPreviousStage"
      >
        驳回上一阶段
      </el-button>
      <el-button @click="drawerVisible = false">取 消</el-button>
      <el-button :loading="submitting" type="primary" @click="submitReview">提交评分</el-button>
    </template>
  </el-drawer>
</template>

<script lang="ts" setup>
import { useDebounceFn } from '@vueuse/core'
import type {
  PerformanceBonusPenaltyRecordVO,
  PerformanceScorePreviewVO
} from '@/api/hrm/performance/assessment'
import * as PerformanceAssessmentApi from '@/api/hrm/portal/performance/assessment'
import {
  HrmPerformanceAssessmentStageStatus,
  HrmPerformanceBonusPenaltyType,
  HrmPerformanceRaterType
} from '@/views/hrm/utils/constants'

defineOptions({ name: 'HrmPortalPerformanceReviewForm' })

const message = useMessage() // 消息弹窗
const drawerVisible = ref(false) // 抽屉是否展示
const loading = ref(false) // 加载中
const submitting = ref(false) // 提交中
const detail = ref<PerformanceAssessmentApi.PortalPerformanceAssessmentVO>({}) // 详情数据
const stageComment = ref('') // 阶段评语
const scorePreview = ref<PerformanceScorePreviewVO>() // 分数预览
const bonusRows = ref<PerformanceBonusPenaltyRecordVO[]>([]) // 加减分记录（score 为带符号分值）
const currentStage = computed(() => detail.value.currentReviewStage) // 当前评分阶段
const canReject = computed(
  () =>
    currentStage.value?.rejectAuthority === true &&
    !!detail.value.reviewStages?.some(
      (stage) =>
        stage.status === HrmPerformanceAssessmentStageStatus.PROCESSED &&
        (stage.sort || 0) < (currentStage.value?.sort || 0)
    )
)

/** 监听抽屉展示状态 */
watch(drawerVisible, (visible) => {
  document.body.classList.toggle('hrm-performance-review-open', visible)
})
/** 清理页面样式 */
onBeforeUnmount(() => document.body.classList.remove('hrm-performance-review-open'))

/** 打开弹窗 */
async function open(assessmentId?: number, stageId?: number) {
  if (!assessmentId || !stageId) {
    return
  }
  drawerVisible.value = true
  loading.value = true
  stageComment.value = ''
  scorePreview.value = undefined
  bonusRows.value = []
  try {
    // 获取表单数据
    detail.value = await PerformanceAssessmentApi.getPerformanceAssessment(assessmentId, stageId)
    stageComment.value = detail.value.currentReviewStage?.comment || ''
    const scoreMap = new Map(
      (detail.value.currentReviewStage?.quotaScoreList || []).map((score) => [
        score.assessmentQuotaId,
        score.score
      ])
    )
    detail.value.quotas?.forEach((quota) => {
      quota.finalScore = scoreMap.get(quota.id)
    })
    initBonusRows()
    schedulePreview()
  } finally {
    loading.value = false
  }
}
defineExpose({ open }) // 提供 open 方法，用于打开组件

const emit = defineEmits(['success']) // 定义组件事件

/** 预览绩效分数 */
async function previewScore() {
  const stage = currentStage.value
  const quotaList = detail.value.quotas || []
  if (
    !detail.value.id ||
    !stage?.id ||
    !quotaList.length ||
    quotaList.some((quota) => quota.finalScore === undefined || quota.finalScore === null)
  ) {
    scorePreview.value = undefined
    return
  }
  try {
    scorePreview.value = await PerformanceAssessmentApi.previewPerformanceAssessmentScore({
      assessmentId: detail.value.id,
      reviewStageId: stage.id,
      quotas: quotaList,
      bonusPenaltyRecords: collectBonusPenaltyRecords()
    })
  } catch {
    scorePreview.value = undefined
  }
}
const schedulePreview = useDebounceFn(previewScore, 250) // 评分预览调度器

/** 驳回至上一评分阶段 */
async function rejectPreviousStage() {
  const stage = currentStage.value
  if (!detail.value.id || !stage?.id) {
    return
  }
  try {
    const { value } = await message.prompt('请输入驳回原因', '驳回上一评分阶段')
    const reason = value?.trim()
    if (!reason) {
      message.warning('驳回原因不能为空')
      return
    }
    submitting.value = true
    await PerformanceAssessmentApi.rejectPerformanceAssessmentReviewStage({
      assessmentId: detail.value.id,
      reviewStageId: stage.id,
      reason
    })
    message.success('上一评分阶段已驳回')
    drawerVisible.value = false
    // 发送操作成功的事件
    emit('success')
  } catch {
  } finally {
    submitting.value = false
  }
}

/** 提交绩效评分 */
async function submitReview() {
  const stage = currentStage.value
  if (!detail.value.id || !stage?.id) {
    return
  }
  const quotaList = detail.value.quotas || []
  if (
    !quotaList.length ||
    quotaList.some((quota) => quota.finalScore === undefined || quota.finalScore === null)
  ) {
    message.error('请完成全部指标评分')
    return
  }
  if (stage.requiredSetting && !stageComment.value.trim()) {
    message.error('请填写本阶段评语')
    return
  }
  // 提交请求
  submitting.value = true
  try {
    await PerformanceAssessmentApi.scorePerformanceAssessment({
      assessmentId: detail.value.id,
      reviewStageId: stage.id,
      comment: stageComment.value.trim(),
      selfComment:
        stage.raterType === HrmPerformanceRaterType.SELF ? stageComment.value.trim() : undefined,
      reviewerComment:
        stage.raterType === HrmPerformanceRaterType.SELF ? undefined : stageComment.value.trim(),
      quotas: quotaList,
      bonusPenaltyRecords: collectBonusPenaltyRecords()
    })
    message.success('当前阶段评分已提交')
    drawerVisible.value = false
    // 发送操作成功的事件
    emit('success')
  } finally {
    submitting.value = false
  }
}

/** 初始化加减分记录 */
function initBonusRows() {
  const items = detail.value.bonusPenaltyItems || []
  const records = detail.value.bonusPenaltyRecords || []
  const recordMap = new Map(records.map((record) => [record.key, record]))
  bonusRows.value = items.map((item) => ({
    key: item.key,
    score: recordMap.get(item.key)?.score || 0,
    reason: recordMap.get(item.key)?.reason || ''
  }))
}

/** 获取某一行加减分数的绝对值（用于输入框展示） */
function proxyGetAbsScore(index: number) {
  return Math.abs(bonusRows.value[index]?.score || 0)
}

/** 写入某一行加减分数；减分项存储为负数 */
function proxySetScore(index: number, value: number | undefined | null) {
  const item = detail.value.bonusPenaltyItems?.[index]
  const row = bonusRows.value[index]
  if (!item || !row) {
    return
  }
  const abs = Number(value) || 0
  row.score = item.type === HrmPerformanceBonusPenaltyType.DEDUCT ? -abs : abs
}

/** 收集有效的加减分记录（分值为 0 的记录不出入提交） */
function collectBonusPenaltyRecords(): PerformanceBonusPenaltyRecordVO[] {
  return bonusRows.value
    .filter((record) => record.score && record.score !== 0)
    .map((record) => ({ key: record.key, score: record.score, reason: record.reason?.trim() || undefined }))
}

/** 格式化带符号分数 */
function formatSignedScore(score?: number) {
  if (score === undefined || score === null) {
    return '-'
  }
  return `${score > 0 ? '+' : ''}${score} 分`
}
</script>

<style scoped>
:global(body.hrm-performance-review-open .el-backtop) {
  display: none;
}
</style>
